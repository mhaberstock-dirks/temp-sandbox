create or replace 
package DIRKSPZM32.PZM_P_SCHICHT_TAG as
  -----------------------------------------------------------------------------------------------
  -- Package: pzm_p_schichttag
  -- Zweck:   Zentrale Validierung und Ermittlung von Schichttagsdaten fuer die Zeiterfassung.
  -- Autor:   wkroeker, Refactoring basierend auf pzm_c_schicht_tag_valid. check_ze_kollision, etc.
  -- Datum:   2026-02
  -- 
  -- Anmerkung: Das Refactoring beschraenkt vorerst darauf, dass lediglich die bestehenden
  --            Funktionen und Prozeduren in diesem Package gebuendelt und mit klaren Schnittstellen
  --            versehen werden.
  --
  -- Dieses Package buendelt alle Operationen, die sich mit der Validierung von erfassten
  -- ZE-Eintraegen und Ermittlung von Abwesenheiten an einem vergangenen Schichttag beschaeftigen.
  --
  -- DESIGN-PRINZIPIEN:
  --   - Klare oeffentliche API nur fuer konkrete Use-Cases (Handler)
  --   - Interne Hilfsfunktionen bleiben privat
  -----------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------
  -- OEFFENTLICHE API:
  -----------------------------------------------------------------------------------------------

  function ist_feiertag_fuer_pers(
    in_datum   in date,
    in_pers_nr in pzm_personal.pers_nr%type,
    in_abt_id  in pzm_abteilungen.abt_id%type default null,
    in_pb_id   in pzm_produktionsbereiche.pb_id%type default null,
    in_kst_id  in pzm_personal.pers_kst_id%type default null
  ) return boolean;

  function ist_feiertag_fuer_pers_legacy_sf(
    in_datum               in date,
    in_pers_nr             in  pzm_personal.pers_nr%type,
    out_sonder_feiertag_kz out varchar2
  ) return boolean;

  function get_feiertag_kennz_fuer_pers(
    in_datum   in date,
    in_pers_nr in pzm_personal.pers_nr%type,
    in_abt_id  in pzm_abteilungen.abt_id%type default null,
    in_pb_id   in pzm_produktionsbereiche.pb_id%type default null,
    in_kst_id  in pzm_personal.pers_kst_id%type default null
  ) return varchar2;

  function ist_feiertag(
    in_datum       in date,
    in_country     in varchar2,
    in_region_code in varchar2 default null
  ) return boolean;

  function get_feiertag(
    in_datum       in date,
    in_country     in varchar2,
    in_region_code in varchar2 default null
  ) return isi_feiertage%rowtype;

  function get_anz_schicht_tage(
    in_pers_nr           in pzm_personal.pers_nr%type,
    in_von_schicht_datum in pzm_zeiterfassung.ze_schicht_tag%type,
    in_bis_schicht_datum in pzm_zeiterfassung.ze_schicht_tag%type
  ) return integer;

  /** 
   * Handler zur Validierung eines Schichttags bei der Zeiterfassung.
   * Validiert die Schichtdaten, prueft auf offene Schichten, Fehlzeitenluecken und berechnet relevante Tageswerte.
   *
   * @param in_pers_nr          Personalnummer des Mitarbeiters
   * @param io_schicht_datum    Datum des Schichttags (in/out)
   * @param io_found_not_closed Flag, ob offene Schichten gefunden wurden (in/out, Wiederverwendung bei Rekursionen)
   * @param io_found_invalid    Flag, ob ungueltige Daten gefunden wurden (in/out, Wiederverwendung bei Rekursionen)
   * @param out_day_sa_kurzname Ermittelte Schichtart fuer den Tag (out)
   * @param out_day_ist_start   Ermittelter Startzeitpunkt eines fehlerhaten ZE-Eintrags der Schicht (out)
   */
  procedure c_schicht_tag_validieren(
    in_pers_nr          in pzm_personal.pers_nr%type,
    io_schicht_datum    in out pzm_zeiterfassung.ze_schicht_tag%type,
    io_found_not_closed in out boolean,
    io_found_invalid    in out boolean,
    out_day_sa_kurzname out pzm_zeiterfassung.ze_sa_kurzname%type,
    out_day_ist_start   out pzm_zeiterfassung.ze_ist_start%type
  );

  /**
   * Handler zur Feststellung/Ermittlung, ob fuer den Mitarbeiter an dem (gesamten)
   * Schichttag eine Abwesenheit (Krankmeldung, Urlaub, Fehlzeit, etc.)
   * eingetragen werden muss.
   *
   * @param in_pers_nr       Personalnummer des Mitarbeiters
   * @param in_schicht_datum Datum des Schichttags
   *
   * @return boolean         true, wenn ein Fehlzeit-Tag existiert, sonst false
   */
  function c_schicht_tag_fehltag_pruefen(
    in_pers_nr          in pzm_personal.pers_nr%type,
    in_schicht_datum    in pzm_zeiterfassung.ze_schicht_tag%type
  ) return boolean;

  /**
   * Handler zur Feststellung/Ermittlung, ob fuer den Mitarbeiter an dem (gesamten)
   * Schichttag eine Fehlzeit-Luecke (z.B. durch unvollstaendige Zeiterfassung) existiert.
   *
   * @param in_pers_nr            Personalnummer des Mitarbeiters
   * @param in_schicht_datum      Datum des Schichttags
   * @param in_day_sa_kurzname    Kurzname der Schichtart fuer den Tag
   * @param in_sa_beginn          Beginn der Schicht laut Schichtart
   * @param in_sa_ende            Ende der Schicht laut Schichtart
   * @param in_day_anw_calc_start Berechneter Startzeitpunkt der Anwesenheit fuer den Tag
   * @param in_day_anw_calc_ende  Berechneter Endzeitpunkt der Anwesenheit fuer den Tag
   * @param in_day_calc_ende      Berechneter Endzeitpunkt fuer die Tagesberechnung (z.B. bei Ueberstunden)
   * @param in_kst_id             Kostenstellen-ID fuer die Tagesberechnung
   * @param in_abt_id             Abteilungs-ID fuer die Tagesberechnung
   * @param in_pb_id              Projekt-/Buchungs-ID fuer die Tagesberechnung
   * @param in_geb_abw_std        Berechnete Abwesenheitsstunden fuer den Tag
   * @param in_arb_std            Berechnete Arbeitsstunden fuer den Tag
   * @param in_day_pause_std      Berechnete Pausenstunden fuer den Tag
   * @param in_zaehler            Zaehler zur Identifikation des ersten bzw. n-ten Durchlaufs bei der Pruefung von Fehlzeit-L?cken (z.B. bei mehreren Schichten am Tag)
   * @param in_std_pro_tag        Standardarbeitsstunden pro Tag laut Schichtart
   *
   * @return boolean              true, wenn eine Fehlzeit-Luecke existiert, sonst false
   */
  function c_schicht_tag_fehlzeit_luecken_pruefen(
    in_pers_nr            in pzm_personal.pers_nr%type,
    in_schicht_datum      in pzm_zeiterfassung.ze_schicht_tag%type,
    in_day_sa_kurzname    in pzm_zeiterfassung.ze_sa_kurzname%type,
    in_sa_beginn          in pzm_schichtarten.sa_beginn%type,
    in_sa_ende            in pzm_schichtarten.sa_ende%type,
    in_day_anw_calc_start in pzm_ze_tagessatz.ts_day_wert_start%type,
    in_day_anw_calc_ende  in pzm_ze_tagessatz.ts_day_wert_ende%type,
    in_day_calc_ende      in pzm_ze_tagessatz.ts_day_wert_ende%type,
    in_kst_id             in pzm_ze_tagessatz.ts_day_kst_id%type,
    in_abt_id             in pzm_ze_tagessatz.ts_day_abt_id%type,
    in_pb_id              in pzm_ze_tagessatz.ts_day_pb_id%type,
    in_geb_abw_std        in pzm_ze_tagessatz.ts_day_abw_std%type,
    in_arb_std            in pzm_ze_tagessatz.ts_day_arb_std%type,
    in_day_pause_std      in pzm_ze_tagessatz.ts_day_pause_std%type,
    in_zaehler            in number,
    in_std_pro_tag        in pzm_schichtarten.sa_std_pro_tag%type
  ) return boolean;
end;
/



-- sqlcl_snapshot {"hash":"cf2e321e20267cb37afef243094c0454bc6fdfb5","type":"PACKAGE_SPEC","name":"PZM_P_SCHICHT_TAG","schemaName":"DIRKSPZM32","sxml":""}