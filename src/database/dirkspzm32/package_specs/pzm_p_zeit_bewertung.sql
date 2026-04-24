create or replace package dirkspzm32.pzm_p_zeit_bewertung is
  -----------------------------------------------------------------------------------------------
  -- Package: pzm_p_zeit_bewertung
  -- Zweck:   Bewertung von Ist-Zeiten (Stempelzeiten) auf berechnete Zeiten
  -- Autor:   wkroeker
  -- Datum:   2026-02
  --
  -- Dieses Package kapselt die komplette Logik zur Bewertung von gestempelten Zeiten:
  --   - Rundung auf konfigurierbares Zeitraster
  --   - Unterscheidung zwischen Festschicht und Gleitzeit
  --   - Gutschriften bei Schichtbeginn/-ende
  --   - Kappung am Schichtende (Überstundenbegrenzung)
  --
  -- DESIGN-PRINZIPIEN:
  --   - Reine Berechnungslogik ohne Datenbankschreibzugriffe
  --   - Alle Eingaben über Record-Typen für Testbarkeit
  --   - Konfigurierbare Rundungsraster (nicht mehr fest 15 Minuten)
  --   - Klare Trennung: Festschicht vs. Gleitzeit
  -----------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------
  -- Konstanten: Berechnungsbasis (aus pzm_schichtarten.calc_basis)
  -----------------------------------------------------------------------------------------------
    calc_basis_festschicht constant varchar2(20 char) := 'FESTZ';
    calc_basis_gleitzeit constant varchar2(20 char) := 'GLEITZ';

  -----------------------------------------------------------------------------------------------
  -- Record-Typ: Bewertungskonfiguration
  -- Enthält alle Parameter, die die Bewertung beeinflussen
  -----------------------------------------------------------------------------------------------
    type t_bewertung_config is record (
    -- Zeitraster
            raster_minuten       number,          -- Rundungsraster in Minuten (z.B. 15, 5, 1)
            gleitz_runden        boolean,         -- Soll bei Gleitzeit gerundet werden?

    -- Gutschriften (in Minuten)
            beginn_gutschr_min   number,          -- Gutschrift am Schichtbeginn
            ende_gutschr_min     number,          -- Gutschrift am Schichtende

    -- Kappung
            kappung_schicht_ende boolean,         -- Überstunden am Schichtende kappen?

    -- Schichtart-Spezifika
            calc_basis           varchar2(20 char), -- 'FESTZ' oder 'GLEITZ'
            sa_ende_nachlauf_min number,          -- Nachlaufzeit (Feierabend-Puffer)
            sa_bewertung_beginn  number           -- 0 = Schichtanfang, 1 = Schichtende
    );

  -----------------------------------------------------------------------------------------------
  -- Record-Typ: Schichtzeiten
  -- Enthält die Soll-Zeiten der Schicht
  -----------------------------------------------------------------------------------------------
    type t_schicht_zeiten is record (
            schicht_tag      date,
            sa_kurzname      varchar2(10 char),
            sa_beginn        date,                 -- Schichtbeginn (absolut)
            sa_ende          date,                 -- Schichtende (absolut)
            sa_ende_effektiv date,                -- Schichtende für Nachtschichten korrigiert
            sa_std_pro_tag   number
    );

  -----------------------------------------------------------------------------------------------
  -- Record-Typ: Bewertungsergebnis
  -----------------------------------------------------------------------------------------------
    type t_bewertung_result is record (
            calc_ist_start date,                 -- Berechnete Startzeit
            calc_ist_ende  date,                 -- Berechnete Endzeit
            ze_std         number,               -- Berechnete Stunden
            schicht_tag    date,                 -- Ermittelter Schichttag
            sa_kurzname    varchar2(10 char)     -- Ermittelte Schichtart
    );

  -----------------------------------------------------------------------------------------------
  -- ÖFFENTLICHE API
  -----------------------------------------------------------------------------------------------

  /**
   * Hauptfunktion: Bewertung von Ist-Zeiten
   *
   * Bewertet gestempelte Start-/Endzeiten unter Berücksichtigung von:
   * - Schichtmodell (Festschicht vs. Gleitzeit)
   * - Zeitraster (konfigurierbar)
   * - Gutschriften
   * - Kappung
   *
   * @param in_pers_nr           Personalnummer
   * @param in_ist_start         Gestempelte Startzeit (kann NULL sein bei manuellen Einträgen)
   * @param in_ist_ende          Gestempelte Endzeit (kann NULL sein bei offenen Einträgen)
   * @param in_ze_status         Status (Anwesend, Abwesend, Pause, Dienstgang)
   * @param in_calc_ist_start    Bereits berechnete Startzeit (für Updates/Korrekturen)
   * @param in_calc_ist_ende     Bereits berechnete Endzeit (für Updates/Korrekturen)
   * @param in_schicht_tag       Bekannter Schichttag (optional)
   * @param in_sa_kurzname       Bekannte Schichtart (optional)
   * @param in_is_erster_eintrag Ist dies der erste Eintrag des Schichttags? (für Beginn-Gutschrift)
   * @return                     Bewertungsergebnis mit berechneten Zeiten
   */
    function bewerte_ist_zeiten (
        in_pers_nr           in number,
        in_ist_start         in date,
        in_ist_ende          in date,
        in_ze_status         in number,
        in_calc_ist_start    in date default null,
        in_calc_ist_ende     in date default null,
        in_schicht_tag       in date default null,
        in_sa_kurzname       in varchar2 default null,
        in_is_erster_eintrag in boolean default false
    ) return t_bewertung_result;

  /**
   * Hilfsfunktion: Lädt die Bewertungskonfiguration für einen Mitarbeiter
   *
   * @param in_pers_nr     Personalnummer
   * @param in_schicht_tag Schichttag (für Tagessatz-Prüfung)
   * @param in_schichtart  Schichtart-Record
   * @return               Bewertungskonfiguration
   */
    function load_bewertung_config (
        in_pers_nr     in number,
        in_schicht_tag in date,
        in_schichtart  in pzm_schichtarten%rowtype
    ) return t_bewertung_config;

end;
/


-- sqlcl_snapshot {"hash":"efac553ea0efa25278e28892bfaf0d8f27571086","type":"PACKAGE_SPEC","name":"PZM_P_ZEIT_BEWERTUNG","schemaName":"DIRKSPZM32","sxml":""}