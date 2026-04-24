create or replace function dirkspzm32.pzm_c_pd_pers_zeit_gen (
    in_sid      in pzm_ze_pers_kst_monat_ab.sid%type,
    in_firma_nr in pzm_ze_pers_kst_monat_ab.firma_nr%type,
    in_datum    in pzm_ze_pers_kst_monat_ab.datum%type,
    in_loa      in pzm_ze_pers_kst_monat_ab.lohnart%type
) return number is
  -- Funktion generiert die daten für die Stundenverteilung
    result number;
begin
  /*
  bde_p_pers_zeit_kst.bde_c_pd_pers_zeit_berech(in_sid,
                                                in_firma_nr,
                                                trunc(in_datum, 'MONTH'),
                                                last_day(in_datum));

  pzm_p_pers_zeit_kst.pzm_c_pd_pers_zeit_berech(in_sid,
                                                in_firma_nr,
                                                in_datum,
                                                in_loa);
  */
    bde_p_pers_zeit_kst.bde_c_pd_pers_zeit_berech(in_sid,
                                                  in_firma_nr,
                                                  trunc(in_datum, 'MONTH') + 6 / 24,
                                                  last_day(in_datum) + 1 + 6 / 24);

    pzm_p_pers_zeit_kst.pzm_c_pd_pers_zeit_berech(in_sid,
                                                  in_firma_nr,
                                                  trunc(in_datum, 'MONTH'),
                                                  in_loa);
    return ( 1 );
end pzm_c_pd_pers_zeit_gen;
/


-- sqlcl_snapshot {"hash":"bd210b87e3cabf1a780fffd6fe7294628f6a71f8","type":"FUNCTION","name":"PZM_C_PD_PERS_ZEIT_GEN","schemaName":"DIRKSPZM32","sxml":""}