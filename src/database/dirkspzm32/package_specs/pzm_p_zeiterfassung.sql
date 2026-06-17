create or replace 
package DIRKSPZM32.PZM_P_ZEITERFASSUNG is
  -----------------------------------------------------------------------------------------------
  -- Package: pzm_p_zeiterfassung
  -- Zweck:   Zentrale Verarbeitung von Zeiterfassungsbuchungen
  -- Autor:   wkroeker, Refactoring basierend auf update_personal_ze_status_date_r55
  -- Datum:   2026-01
  --
  -- Dieses Package trennt die verschiedenen Buchungsquellen und Use Cases:
  --   1. Live-Stempeln (App, Terminal in Echtzeit)
  --   2. Terminal-Sync (verzoegerte Buchungen von Offline-Terminals)
  --   3. Manuelle Korrekturen (Nachbuchungen durch Benutzer)
  --
  -- Erweiterung ze_typ:
  --   NULL = Legacy/unbekannt
  --   'A'  = Automatisch generiert (Fehlzeiten, Feiertage)
  --   'M'  = Manuell eingetragen/korrigiert
  --   'T'  = Terminal-Buchung (Stempelterminal)
  --   'L'  = Live-Stempeln (App)
  --   'O'  = Offline erfasste Buchung (i.d.R. App)
  --   'S'  = System-generiert (z.B. Auto-Close)
  --
  -- DESIGN-PRINZIPIEN:
  --   - Alle Berechnungen (Schichttag, calc_ist_start/ende, ze_std) werden deterministisch
  --     VOR dem INSERT/UPDATE ausgefuehrt, nicht reaktiv im Trigger
  --   - Klare oeffentliche API nur fuer konkrete Use-Cases (Handler)
  --   - Interne Hilfsfunktionen bleiben privat
  -----------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------
  -- Konstanten: Status-Werte
  -----------------------------------------------------------------------------------------------
  STATUS_ABWESEND   constant number := 0;
  STATUS_ANWESEND   constant number := 2;
  STATUS_PAUSE      constant number := 4;
  STATUS_DIENSTGANG constant number := 5;
  STATUS_FEIERTAG   constant number := 6;
  STATUS_SERVICE    constant number := 7;

  -----------------------------------------------------------------------------------------------
  -- Konstanten: Work-Location-Werte
  -----------------------------------------------------------------------------------------------
  WORK_LOCATION_BETRIEB    constant number := 1; -- "Betrieb" OnSite (Default fuer Anwesend in der Firma)
  WORK_LOCATION_OFFICE     constant number := 2; -- "Buero", Office (z.B. Firmenstandort, aber nicht im Betrieb)
  WORK_LOCATION_HOMEOFFICE constant number := 3; -- "HomeOffice", Arbeiten von zu Hause
  WORK_LOCATION_REMOTE     constant number := 4; -- "Remote", Arbeiten von unterwegs (z.B. Cafe, Kundenstandort)

  WORK_LOCATION_REISE_AKTIV  constant number := 51; -- "Reise (aktiv)", TravelActive
  WORK_LOCATION_REISE_PASSIV constant number := 52; -- "Reise (passiv)", TravelPassive
  WORK_LOCATION_UNTERWEGS    constant number := 53; -- "Unterwegs", OffSite (Default fuer Dienstreise)
  WORK_LOCATION_MONTAGE      constant number := 54; -- "Montage", FieldWork, Installation/Setup vor Ort
  WORK_LOCATION_AUSSENDIENST constant number := 55; -- "Aussendienst", FieldService, Sales/Consulting vor Ort

  -----------------------------------------------------------------------------------------------
  -- Konstanten: Buchungs-Typen (ze_typ)
  -----------------------------------------------------------------------------------------------
  TYP_LEGACY        constant varchar2(10 char) := null;   -- Bestehende Daten ohne Typ (legacy live Buchung)
  TYP_AUTO          constant varchar2(10 char) := 'A';    -- Automatisch generiert
  TYP_MANUELL       constant varchar2(10 char) := 'M';    -- Manuell eingetragen
  TYP_TERMINAL      constant varchar2(10 char) := 'T';    -- Terminal-Buchung
  TYP_LIVE          constant varchar2(10 char) := 'L';    -- Live-Stempeln (App)
  TYP_OFFLINE       constant varchar2(10 char) := 'O';    -- Offline-Buchung (App)
  TYP_SYSTEM        constant varchar2(10 char) := 'S';    -- System-generiert

  -----------------------------------------------------------------------------------------------
  -- Konstanten: Aktionen der Zeiterfassung (aus Terminal-Eintraegen oder Live-Stempeln)
  -----------------------------------------------------------------------------------------------
  AKTION_KOMMEN     constant varchar2(1 char) := 'K'; -- Anwesend / Arbeitsbeginn (Start-Aktion)
  AKTION_GEHEN      constant varchar2(1 char) := 'G'; -- Abwesend / Arbeitsende
  AKTION_PAUSE      constant varchar2(1 char) := 'P'; -- Pause waehrend Anwesend (Start-Aktion)
  AKTION_DIENSTGANG constant varchar2(1 char) := 'D'; -- Reise, Montage, Aussendienst (Start-Aktion)
  AKTION_SERVICE    constant varchar2(1 char) := 'S'; -- Rufbereitschaft / Service (Start-Aktion)

  -----------------------------------------------------------------------------------------------
  -- Konstanten: Buchungsquellen
  -----------------------------------------------------------------------------------------------
  QUELLE_LIVE       constant varchar2(20 char) := 'LIVE';
  QUELLE_APP        constant varchar2(20 char) := 'APP';
  QUELLE_TERMINAL   constant varchar2(20 char) := 'TERMINAL';
  QUELLE_MANUELL    constant varchar2(20 char) := 'MANUELL';
  QUELLE_SYSTEM     constant varchar2(20 char) := 'SYSTEM';

  -----------------------------------------------------------------------------------------------
  -- Record-Typ fuer Buchungskontext (oeffentlich fuer fortgeschrittene Integrationen)
  -----------------------------------------------------------------------------------------------
  type t_buchung_context is record (
    pers_nr         pzm_personal.pers_nr%type,
    zeitstempel     date, -- lokale Zeit aus Sicht des Mitarbeiters
    timezone_name   varchar2(50 char),  -- lokaler IANA Timezone Name (z.B. 'Europe/Berlin')
    aktion          varchar2(3 char), -- Aktion: bspw. 'K'=Kommen, 'G'=Gehen, 'P'=Pause, 'D'=Dienstgang, 'S'=Service
    work_location   pzm_zeiterfassung.ze_work_location%type,

    quelle          varchar2(20 char), -- Quelle der Buchung (z.B. 'LIVE', 'APP', 'TERMINAL', 'MANUELL', 'SYSTEM')
    terminal_id     varchar2(50 char), -- Terminal-ID (optional, z.B. fuer TERMINAL-Buchungen)
    rfid            varchar2(50 char), -- RFID/Transponder-Code (optional, z.B. fuer TERMINAL-Buchungen)

    -- Stammdaten (deterministisch vorab ermittelbar)
    schicht_tag     pzm_zeiterfassung.ze_schicht_tag%type,
    sa_kurzname     pzm_zeiterfassung.ze_sa_kurzname%type,
    sm_name         pzm_zeiterfassung.ze_sm_name%type,

    -- Aktueller Status (deterministisch vorab ermittelbar)
    ze_status       pzm_zeiterfassung.ze_status%type,
    ze_typ          pzm_zeiterfassung.ze_typ%type,

    -- Optional: Kostenstellen/Abteilungen (kann aus Stammdaten oder Buchungsdaten kommen)
    kst_id          pzm_personal.pers_kst_id%type, -- Kostenstelle
    abt_id          pzm_personal.pers_abt_id%type, -- Abteilung/Organisationseinheit
    pb_id           pzm_personal.pers_pb_id%type,  -- Produktionsbereich/PZM Mandant/Betrieb

    -- Berechnete Werte (deterministische Vorberechnung)
    calc_ist_start  pzm_zeiterfassung.ze_calc_ist_start%type,
    calc_ist_ende   pzm_zeiterfassung.ze_calc_ist_ende%type,
    ze_std          number
  );

  -----------------------------------------------------------------------------------------------
  -- OEFFENTLICHE API: Spezialisierte Handler fuer konkrete Use-Cases
  -----------------------------------------------------------------------------------------------

  /**
   * Allgemeiner Handler um Terminal-Buchungen einzeln zu erfassen.
   * Speichert den Zeitstempel in 'pzm_zeiterfassung_eintraege'.
   * Kann sowohl Echtzeit- als auch verzoegerte Buchungen speichern.
   * Die hiergespeicherten Eintraege werden spaeter von einem Batch-Job
   * verarbeitet und via 'c_stempelzeit_ze_sync' in die Haupttabelle
   * 'pzm_zeiterfassung' uebertragen.
   *
   * @param in_quelle        Quelle der Buchung (z.B. 'LIVE', 'APP', 'TERMINAL')
   * @param in_terminal_id   Terminal-ID (optional, z.B. fuer TERMINAL-Buchungen)
   * @param in_rfid          RFID/Transponder-Code (optional, z.B. fuer TERMINAL-Buchungen)
   * @param in_aktion        Aktion: 'K'=Kommen, 'G'=Gehen, 'P'=Pause, 'D'=Dienstgang
   * @param in_zeitstempel   lokaler Zeitstempel der Buchung (erforderlich)
   * @param in_timezone_name Zeitzonen-Name des lokalen Zeitstempel (erforderlich)
   * @param in_ze_transfer_status Uebertragungsstatus in die Haupttabelle
   */
  procedure c_stempelzeit_eintragen(
    in_quelle        in  varchar2,
    in_terminal_id   in  varchar2,
    in_rfid          in  varchar2,
    in_aktion        in  varchar2,
    in_zeitstempel   in  date,
    in_timezone_name in  varchar2,  -- IANA Timezone Name
    in_ze_transfer_status in varchar2 default 'N'
  );

  /**
   * Handler fuer Live-Stempeln (App, Echtzeit-Terminal)
   * Verwendet immer SYSDATE als Zeitstempel.
   *
   * @param in_pers_nr       Personalnummer
   * @param in_aktion        Aktion: 'K'=Kommen, 'G'=Gehen, 'P'=Pause, 'D'=Dienstgang
   * @param in_timezone_name Zeitzonen-Name (IANA) auf dessen Basis der Zeitstempel (live) generiert wird (erforderlich)
   * @param in_kst_id        Kostenstelle (optional, sonst aus Stammdaten)
   * @param in_abt_id        Abteilung/Organisationseinheit (optional, sonst aus Stammdaten)
   * @param in_work_location Arbeitsort-ID (optional)
   * @param in_frontend_name Frontend-Name (optional, z.B. 'MobileApp', 'Terminal123')
   *
   * @return ze_id des erstellten Zeiterfassungs-Eintrags in 'pzm_zeiterfassung' (nicht in 'pzm_zeiterfassung_eintraege')
   * @throws Exception wenn die Buchung nicht verarbeitet werden konnte (z.B. ungültige Aktion, ungültige Personalnummer, etc.)
   */
  function c_live_stempeln(
    in_pers_nr       in  number,
    in_aktion        in  varchar2,
    in_timezone_name in  varchar2,  -- IANA Timezone Name
    in_kst_id        in  number   default null,
    in_abt_id        in  number   default null,
    in_work_location in  number   default null,
    in_frontend_name in  varchar2 default null
  ) return pzm_zeiterfassung.ze_id%type;

  /**
   * Handler fuer Stempelzeit-Sync (verzoegerte Buchungen von (Offline-)Terminals)
   * Kann beliebige Zeitstempel in der Vergangenheit verarbeiten.
   * Sucht Eintraege basierend auf Schichttag, nicht auf Zeitfenster.
   *
   * @param in_quelle        Quelle der Buchung (z.B. 'LIVE', 'APP', 'TERMINAL')
   * @param in_pers_nr       Personalnummer
   * @param in_aktion        Aktion: 'K'=Kommen, 'G'=Gehen, 'P'=Pause, 'D'=Dienstgang
   * @param in_zeitstempel   lkaler Zeitstempel der Buchung (erforderlich)
   * @param in_timezone_name Zeitzonen-Name des (lokalen) Zeitstempel (erforderlich)
   * @param in_kst_id        Kostenstelle (optional, sonst aus Stammdaten)
   * @param in_abt_id        Abteilung/Organisationseinheit (optional, sonst aus Stammdaten)
   * @param in_terminal_id   Terminal-ID (optional)
   * @param in_rfid          RFID-/Transponder-Code (optional)
   * @param in_work_location Arbeitsort-ID (optional)
   *
   * @return ze_id des erstellten oder aktualisierten Zeiterfassungs-Eintrags in 'pzm_zeiterfassung' (nicht in 'pzm_zeiterfassung_eintraege')
   * @throws Exception wenn die Buchung nicht verarbeitet werden konnte (z.B. ungültige Aktion, ungültige Personalnummer, etc.)
   */
  function c_stempelzeit_ze_sync(
    in_quelle        in  varchar2,
    in_pers_nr       in  number,
    in_aktion        in  varchar2,
    in_zeitstempel   in  date,
    in_timezone_name in  varchar2,  -- IANA Timezone Name
    in_kst_id        in  number   default null,
    in_abt_id        in  number   default null,
    in_terminal_id   in  varchar2 default null,
    in_rfid          in  varchar2 default null,
    in_work_location in  number   default null
  ) return pzm_zeiterfassung.ze_id%type;

  /**
   * Handler fuer manuelle Korrekturen einer Zeiterfassung.
   * Erstellt neue (manuelle) Einträge mit vollstaendigen Daten.
   *
   * @param in_korr_pers_nr          Personalnummer der korrigierenden Person
   * @param in_pers_nr               Personalnummer
   * @param in_ze_status             Status der Zeiterfassung (typisch: STATUS_ANWESEND, STATUS_PAUSE, STATUS_DIENSTGANG, etc.)
   * @param in_schicht_tag           Schichttag
   * @param in_sa_kurzname           Schichtart-Kurzname
   * @param in_start_zeit            manuell festgelegte Start-Zeit
   * @param in_start_timezone_name   IANA Timezone Name der Startzeit (typischerweise 'Europe/Berlin')
   * @param in_ende_zeit             manuell festgelegte Ende-Zeit
   * @param in_ende_timezone_name    IANA Timezone Name, bei NULL gleiche TZ wie start
   * @param in_work_location         Arbeitsort-ID (optional, wird ggf. automatisch anhand des 'ze_status' ermittelt)
   * @param in_schicht_tag_auswerten Flag, ob die Auswertung des Schichttags erfolgen soll (Standard: true)
   *
   * @return ze_id des erstellten oder aktualisierten Zeiterfassungs-Eintrags in 'pzm_zeiterfassung' (nicht in 'pzm_zeiterfassung_eintraege')
   * @throws Exception wenn die Buchung nicht verarbeitet werden konnte (z.B. ungültige Aktion, ungültige Personalnummer, etc.)
   */
  function c_ze_zeiten_anlegen(
    in_korr_pers_nr          in  number,
    in_pers_nr               in  number,
    in_ze_status             in  number,
    in_schicht_tag           in  date,
    in_sa_kurzname           in  varchar2,
    in_start_zeit            in  date,
    in_start_timezone_name   in  varchar2,
    in_ende_zeit             in  date,
    in_ende_timezone_name    in  varchar2 default null,
    in_work_location         in  number   default null,
    in_schicht_tag_auswerten in  boolean  default true
  ) return pzm_zeiterfassung.ze_id%type;

  /**
   * Handler fuer manuelle Korrekturen von Zeiten eines Zeiterfassungs-Eintrags.
   *
   * @param in_korr_pers_nr          Personalnummer der korrigierenden Person
   * @param in_ze_id                 ZE-ID fuer Update (NULL = neuer Eintrag)
   * @param in_ze_status             Status der Zeiterfassung (typisch: STATUS_ANWESEND, STATUS_PAUSE, STATUS_DIENSTGANG, etc.)
   * @param in_schicht_tag           Schichttag
   * @param in_sa_kurzname           Schichtart-Kurzname
   * @param in_start_zeit            manuell festgelegte Start-Zeit
   * @param in_start_timezone_name   IANA Timezone Name der Startzeit (typischerweise 'Europe/Berlin')
   * @param in_ende_zeit             manuell festgelegte Ende-Zeit
   * @param in_ende_timezone_name    IANA Timezone Name, bei NULL gleiche TZ wie start
   * @param in_work_location         Arbeitsort-ID (optional)
   * @param in_schicht_tag_auswerten Flag, ob die Auswertung des Schichttags erfolgen soll (Standard: true)
   *
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige ZE-ID, ungültige Personalnummer, etc.)
   */
  procedure c_ze_zeiten_korrigieren(
    in_korr_pers_nr          in  number,
    in_ze_id                 in  number,
    in_ze_status             in  number,
    in_schicht_tag           in  date,
    in_sa_kurzname           in  varchar2,
    in_start_zeit            in  date,
    in_start_timezone_name   in  varchar2,
    in_ende_zeit             in  date,
    in_ende_timezone_name    in  varchar2 default null,  -- IANA Timezone Name, bei NULL gleiche TZ wie start
    in_schicht_tag_auswerten in  boolean  default true
  );

  /**
   * Handler fuer manuelle Korrekturen von Zuordnungen (Kostenstelle, Abteilung, Produktionsbereich).
   *
   * @param in_korr_pers_nr          Personalnummer der korrigierenden Person
   * @param in_ze_id                 ZE-ID fuer Update (muss existieren)
   * @param in_kst_id                neue Kostenstelle (optional, sonst unverändert)
   * @param in_abt_id                neue Abteilung/Organisationseinheit (optional, sonst unverändert)
   * @param in_pb_id                 neuer Produktionsbereich/PZM Mandant/Betrieb (optional, sonst unverändert)
   * @param in_schicht_tag_auswerten Flag, ob die Auswertung des Schichttags erfolgen soll
   *                                 (Standard: false, da sich die Zuordnung nicht auf die Schichttag-Auswertung auswirken sollte)
   *
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige ZE-ID, ungültige Personalnummer, etc.)
   */
  procedure c_ze_zuordnung_korrigieren(
    in_ze_id         in  number,
    in_kst_id        in  number,
    in_abt_id        in  number,
    in_pb_id         in  number,
    in_schicht_tag_auswerten in boolean default false
  );

  /**
   * Handler fuer manuelle Korrekturen von Schichtzuordnungen (Schichttag, Schichtart).
   * Mindestens einer der beiden Werte (Schichttag oder Schichtart) muss angegeben werden,
   * damit die Korrektur wirksam wird.
   *
   * @param in_ze_id                 ZE-ID fuer Update (muss existieren)
   * @param in_schicht_tag_neu       neuer Schichttag (optional, sonst unverändert)
   * @param in_sa_kurzname_neu       neuer Schichtart-Kurzname (optional, sonst unverändert)
   * @param in_schicht_tag_auswerten Flag, ob die Auswertung des Schichttags erfolgen soll
   *                                 (Standard: true, da sich die Schichtzuordnung auf die Schichttag-Auswertung auswirken sollte)
   *
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige ZE-ID, ungültige Personalnummer, etc.)
   */
  procedure c_ze_schicht_korrigieren(
    in_ze_id                 in  number,
    in_schicht_tag_neu       in  date default null,
    in_sa_kurzname_neu       in  varchar2 default null,
    in_schicht_tag_auswerten in  boolean  default true
  );

  /**
   * Erweiterter Handler fuer manuelle Korrekturen von Schichtzuordnungen (Schichttag, Schichtart)
   * fuer alle Eintraege eines Mitarbeiters an einem Schichttag.
   * Korrigiert alle Eintraege, die mit dem alten Schichttag übereinstimmen,
   * auf den neuen Schichttag und/oder die neue Schichtart.
   * Mindestens einer der beiden Werte (Schichttag oder Schichtart) muss angegeben werden,
   * damit die Korrektur wirksam wird.
   * Diese Funktion ist besonders nützlich, wenn sich der Schichttag eines Mitarbeiters ändert
   * (z.B. durch Nachtschicht, Schichtmodell-Änderung, etc.) und alle Einträge entsprechend angepasst werden müssen.
   *
   * @param in_pers_nr               Personalnummer
   * @param in_schicht_tag           alter Schichttag, der korrigiert werden soll (muss existieren)
   * @param in_schicht_tag_neu       neuer Schichttag (optional, sonst unverändert)
   * @param in_sa_kurzname_neu       neuer Schichtart-Kurzname (optional, sonst unverändert)
   * @param in_schicht_tag_auswerten Flag, ob die Auswertung des Schichttags erfolgen soll
   *                                 (Standard: true, da sich die Schichtzuordnung auf die Schichttag-Auswertung auswirken sollte)
   *
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige Personalnummer, ungültige Schichttage, etc.)
   */
  procedure c_ze_schicht_korrigieren_alle(
    in_pers_nr               in  number,
    in_schicht_tag           in  date,
    in_schicht_tag_neu       in  date default null,
    in_sa_kurzname_neu       in  varchar2 default null,
    in_schicht_tag_auswerten in  boolean  default true
  );

  /**
   * Handler fuer das Loeschen eines Zeiterfassungs-Eintrags.
   *
   * @param in_korr_pers_nr          Personalnummer der korrigierenden Person
   * @param in_ze_id                 ZE-ID fuer Loeschen (muss existieren)
   * @param in_schicht_tag_auswerten Flag, ob die Auswertung des Schichttags erfolgen soll
   *                                 (Standard: true, da das Loeschen eines Eintrags Auswirkungen auf die Schichttag-Auswertung haben kann)
   *
   * @throws Exception wenn das Loeschen nicht verarbeitet werden konnte (z.B. ungültige ZE-ID, etc.)
   */
  procedure c_ze_loeschen(
    in_korr_pers_nr          in  number,
    in_ze_id                 in  number,
    in_schicht_tag_auswerten in  boolean  default true
  );

  /**
   * Spezieller Handler fuer das Anlegen von Abwesenheitszeiten (z.B. Urlaub, Krankheit).
   * Erstellt neue Einträge mit vollstaendigen Daten.
   *
   * @param in_korr_pers_nr          Personalnummer der korrigierenden Person
   * @param in_pers_nr               Personalnummer
   * @param in_ze_aa_id              Abwesenheitsart-ID (z.B. Urlaub, Krankheit)
   * @param in_schicht_tag           Schichttag
   * @param in_sa_kurzname           Schichtart-Kurzname
   * @param in_start_zeit            manuell festgelegte Start-Zeit
   * @param in_ende_zeit             manuell festgelegte Ende-Zeit
   * @param in_schicht_tag_auswerten Flag, ob die Auswertung des Schichttags erfolgen soll (Standard: true)
   *
   * @return ze_id des erstellten oder aktualisierten Zeiterfassungs-Eintrags in 'pzm_zeiterfassung'
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige Personalnummer, ungültige Abwesenheitsart, etc.)
   */
  function c_abwesenheit_anlegen(
    in_korr_pers_nr          in  number,
    in_pers_nr               in  number,
    in_ze_aa_id              in  number,
    in_schicht_tag           in  date,
    in_sa_kurzname           in  varchar2,
    in_start_zeit            in  date,
    in_ende_zeit             in  date,
    in_schicht_tag_auswerten in  boolean  default true
  ) return pzm_zeiterfassung.ze_id%type;

  /**
   * Spezieller Handler fuer das Korrigieren von Abwesenheitszeiten (z.B. Urlaub, Krankheit).
   * Arbeitet auf bestehenden ZE-Eintraegen.
   *
   * @param in_korr_pers_nr          Personalnummer der korrigierenden Person
   * @param in_ze_id                 ZE-ID fuer Update (muss existieren)
   * @param in_ze_aa_id              Abwesenheitsart-ID (z.B. Urlaub, Krankheit)
   * @param in_schicht_tag           Schichttag
   * @param in_sa_kurzname           Schichtart-Kurzname
   * @param in_start_zeit            manuell festgelegte Start-Zeit
   * @param in_ende_zeit             manuell festgelegte Ende-Zeit
   * @param in_schicht_tag_auswerten Flag, ob die Auswertung des Schichttags erfolgen soll (Standard: true)
   *
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige ZE-ID, ungültige Personalnummer, ungültige Abwesenheitsart, etc.)
   */
  procedure c_abwesenheit_korrigieren(
    in_korr_pers_nr          in  number,
    in_ze_id                 in  number,
    in_ze_aa_id              in  number,
    in_schicht_tag           in  date,
    in_sa_kurzname           in  varchar2,
    in_start_zeit            in  date,
    in_ende_zeit             in  date,
    in_schicht_tag_auswerten in  boolean  default true
  );

  /**
   * Spezieller Handler fuer das Anlegen von Fehlzeiten (z.B. Krankheit, unentschuldigtes Fehlen).
   * Erstellt neue Einträge mit vollstaendigen Daten.
   *
   * @param in_pers_nr               Personalnummer
   * @param in_schicht_tag           Schichttag
   * @param in_aa_id                 Abwesenheitsart-ID (z.B. Krankheit, unentschuldigtes Fehlen)
   * @param in_sa_kurzname           Schichtart-Kurzname (optional, kann aus Schichtmodell ermittelt werden)
   * @param in_fehlzeit_start        Start-Zeit der Fehlzeit (optional, sonst Schichtbeginn)
   * @param in_fehlzeit_ende         Ende-Zeit der Fehlzeit (optional, sonst Schichtende)
   *
   * @return ze_id des erstellten oder aktualisierten Zeiterfassungs-Eintrags in 'pzm_zeiterfassung'
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige Personalnummer, ungültige Abwesenheitsart, etc.)
   */
  function c_automatische_fehlzeit_eintragen(
    in_pers_nr        in  number,
    in_schicht_tag    in  date,
    in_aa_id          in  number,
    in_sa_kurzname    in  varchar2 default null,
    in_fehlzeit_start in  date     default null,
    in_fehlzeit_ende  in  date     default null
  ) return pzm_zeiterfassung.ze_id%type;

  /**
   * Spezieller Handler fuer das Anlegen von Pausen.
   * Erstellt neue Einträge mit vollstaendigen Daten.
   *
   * @param in_pers_nr        Personalnummer
   * @param in_schicht_tag    Schichttag
   * @param in_sa_kurzname    Schichtart-Kurzname
   * @param in_pause_start    Start-Zeit der Pause
   * @param in_pause_ende     Ende-Zeit der Pause
   *
   * @return ze_id des erstellten oder aktualisierten Zeiterfassungs-Eintrags in 'pzm_zeiterfassung'
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige Personalnummer, ungültige Zeiten, etc.)
   */
  function c_automatische_pause_eintragen(
    in_pers_nr        in  number,
    in_schicht_tag    in  date,
    in_sa_kurzname    in  varchar2,
    in_pause_start    in  date,
    in_pause_ende     in  date
  ) return pzm_zeiterfassung.ze_id%type;

  /**
   * Spezieller Handler fuer das Anlegen von Feiertagen.
   * Erstellt neue Einträge mit vollstaendigen Daten.
   *
   * @param in_pers_nr        Personalnummer
   * @param in_schicht_tag    Schichttag
   * @param in_sa_kurzname    Schichtart-Kurzname (optional, kann aus Schichtmodell ermittelt werden)
   * @param in_feiertag_start Start-Zeit des Feiertags (optional, relevant bei halben Feiertagen, sonst Schichtbeginn)
   * @param in_feiertag_ende  Ende-Zeit des Feiertags (optional, relevant bei halben Feiertagen, sonst Schichtende)
   *
   * @return ze_id des erstellten oder aktualisierten Zeiterfassungs-Eintrags in 'pzm_zeiterfassung'
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige Personalnummer, ungültige Zeiten, etc.)
   */
  function c_automatischen_feiertag_eintragen(
    in_pers_nr        in  number,
    in_schicht_tag    in  date,
    in_sa_kurzname    in  varchar2 default null,
    in_feiertag_start in  date     default null,
    in_feiertag_ende  in  date     default null
  ) return pzm_zeiterfassung.ze_id%type;

  /**
   * Spezieller Handler fuer das Anlegen von automatischen Anwesenheitszeiten
   * (z.B. bei automatischen Prozessen und entsprechenden hinterlegten Konfigurationen).
   * Erstellt neue Einträge mit vollstaendigen Daten.
   *
   * @param in_pers_nr           Personalnummer
   * @param in_schicht_tag       Schichttag
   * @param in_sa_kurzname       Schichtart-Kurzname
   * @param in_anwesenheit_start Start-Zeit der Anwesenheit
   * @param in_anwesenheit_ende  Ende-Zeit der Anwesenheit
   * @param in_aa_id             Abwesenheitsart-ID (optional, z.B. für spezielle Abwesenheitsarten, die als Anwesenheit deklariert wurden)
   *
   * @return ze_id des erstellten oder aktualisierten Zeiterfassungs-Eintrags in 'pzm_zeiterfassung'
   * @throws Exception wenn die Korrektur nicht verarbeitet werden konnte (z.B. ungültige Personalnummer, ungültige Zeiten, etc.)
   */
  function c_automatische_anwesenheit_eintragen(
    in_pers_nr           in  number,
    in_schicht_tag       in  date,
    in_sa_kurzname       in  varchar2,
    in_anwesenheit_start in  date,
    in_anwesenheit_ende  in  date,
    in_aa_id             in  number default null -- optional, wenn vorhanden
  ) return pzm_zeiterfassung.ze_id%type;

  -----------------------------------------------------------------------------------------------
  -- OEFFENTLICHE ABFRAGE-FUNKTIONEN (Read-Only, keine Seiteneffekte)
  -----------------------------------------------------------------------------------------------

  /**
   * Liefert die Personalnummer des Mitarbeiters basierend auf der übergebenen RFID (Transponder-Code).
   * Gibt eine Exception zurück, wenn kein Mitarbeiter mit der angegebenen RFID gefunden wird.
   */
  function get_pers_nr_by_rfid(
    in_rfid in varchar2
  ) return pzm_personal.pers_nr%type;

  /**
   * Ermittelt die Standard-Work-Location fuer einen gegebenen Zeiterfassungsstatus.
   */
  function get_default_work_location(in_ze_status in number) return number;

  /**
   * Ermittelt den Schichttag fuer einen gegebenen Zeitstempel.
   * Beruecksichtigt Nachtschichten und Schichtmodell des Mitarbeiters.
   */
  function get_schicht_tag_fuer_zeit(
    in_pers_nr     in number,
    in_zeitstempel in date
  ) return date;

  /**
   * Findet einen offenen Eintrag fuer einen Mitarbeiter am gegebenen Schichttag.
   * Gibt NULL zurueck wenn kein offener Eintrag existiert.
   */
  function find_offener_eintrag_id(
    in_pers_nr     in number,
    in_schicht_tag in date
  ) return pzm_zeiterfassung.ze_id%type;

  -----------------------------------------------------------------------------------------------
  -- TEMP-OEFFENTLICHE TEST-FUNKTIONEN (nur fuer Unit-Tests)
  -----------------------------------------------------------------------------------------------
  procedure ze_ist_zeiten_bewerten(
    io_ze_context in out t_buchung_context,
    in_ist_start  in     date,
    in_ist_ende   in     date
  );

end;
/



-- sqlcl_snapshot {"hash":"43ac7c36d9b4ac1e21e011ef2c7b96194f38f372","type":"PACKAGE_SPEC","name":"PZM_P_ZEITERFASSUNG","schemaName":"DIRKSPZM32","sxml":""}