create or replace 
package PZM_SCHICHT_PLANUNG is
  -----------------------------------------------------------------------------------------------
  -- Package: PZM_SCHICHT_PLANUNG
  -- Zweck:   Funktionen und prozeduren zur Schichtplanung
  -- Autor:   hjgoedeke
  -- Datum:   2026-09
  --
  -----------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------
  -- Konstanten: Buchungsquellen
  -----------------------------------------------------------------------------------------------
  QUELLE_LIVE       constant varchar2(20 char) := 'LIVE';
  QUELLE_APP        constant varchar2(20 char) := 'APP';
  QUELLE_TERMINAL   constant varchar2(20 char) := 'TERMINAL';
  QUELLE_MANUELL    constant varchar2(20 char) := 'MANUELL';
  QUELLE_SYSTEM     constant varchar2(20 char) := 'SYSTEM';


  -----------------------------------------------------------------------------------------------
  -- ÖFFENTLICHE API
  -----------------------------------------------------------------------------------------------

  /**
   * Hauptfunktion: Planeintrag pruefen
   *
   * @return                     Ergebnis
   */
  function pruefe_schicht_plan_eintrag(
    in_pers_nr           in pzm_personal.pers_nr%type,
    in_vq_id             in pzm_vorgangsqualifikation.vq_id%type,
    in_schicht_tag       in date,
    in_start             in date,
    in_ende              in date
  ) return varchar2;

  procedure gen_schichtplan_aus_bedarf(
    in_ResponsibleId     in pzm_abt_leitung.abt_l_pers_nr%type,
    in_vq_abt_id         in pzm_vorgangsqualifikation.vq_abt_id%type,
    in_w_plan_start      in pzm_vorgangsqual_w_plan.w_plan_start%type,
    in_w_plan_schicht    in pzm_vorgangsqual_w_plan.w_plan_schicht%type
  );
  
end;
/



-- sqlcl_snapshot {"hash":"43da6ac2b881ad27e7641dc08271f9455a8585f5","type":"PACKAGE_SPEC","name":"PZM_SCHICHT_PLANUNG","schemaName":"DIRKSPZM32","sxml":""}