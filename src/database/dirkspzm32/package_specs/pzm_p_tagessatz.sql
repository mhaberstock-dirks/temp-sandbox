create or replace
package DIRKSPZM32.PZM_P_TAGESSATZ as
  -----------------------------------------------------------------------------------------------
  -- Package: pzm_p_tagessatz
  -- Zweck:   Berechnung des Tagessatzes (Stundensaldi) pro Mitarbeiter und Schichttag.
  --          Refactoring von UPDATE_PERS_ZE_TAG als Package mit gekapselten Berechnungsschritten.
  -- Autor:   M.Haberstock, W24120-635
  -- Datum:   2026-07
  --
  -- DESIGN-PRINZIPIEN:
  --   - Oeffentliche API: ein einziger Einstiegspunkt c_berechnen
  --   - Interne Berechnungsschritte als private Prozeduren (kein rekursiver Aufruf mehr)
  --   - While-Schleife ersetzt Rekursion (max. 3 Durchlaeufe)
  --   - Einheitliches snake_case-Naming
  --   - Kein toter Code (if 1=2 entfernt)
  -----------------------------------------------------------------------------------------------

  /**
   * Berechnet den Tagessatz (alle Stundensaldi) fuer einen Mitarbeiter und einen Schichttag.
   * Entspricht der bisherigen Standalone-Prozedur UPDATE_PERS_ZE_TAG.
   *
   * @param p_pers_nr   Personalnummer des Mitarbeiters
   * @param p_datum     Datum des Schichttags
   * @param p_result    Rueckgabecode: 0 = OK, -1 = keine Stempelzeit, -2 = Person nicht angestellt
   * @param p_res_info  Textuelle Beschreibung des Ergebnisses
   */
  procedure c_berechnen(
    p_pers_nr  in  number,
    p_datum    in  date,
    p_result   out number,
    p_res_info out varchar2
  );

end PZM_P_TAGESSATZ;
/



-- sqlcl_snapshot {"hash":"","type":"PACKAGE_SPEC","name":"PZM_P_TAGESSATZ","schemaName":"DIRKSPZM32","sxml":""}
