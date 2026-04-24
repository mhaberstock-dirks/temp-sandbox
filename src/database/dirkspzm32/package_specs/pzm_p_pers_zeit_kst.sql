create or replace package dirkspzm32.pzm_p_pers_zeit_kst is

  -- Author  : HJGOEDEKE
  -- Created : 04.04.2011 13:55:40
  -- Purpose : Funktionen für die Zeitverteilung Presonal auf Resource

  -- Public function and procedure declarations
    procedure pzm_c_pd_pers_zeit_berech (
        in_sid      in pzm_ze_pers_kst_monat_ab.sid%type,
        in_firma_nr in pzm_ze_pers_kst_monat_ab.firma_nr%type,
        in_datum    in pzm_ze_pers_kst_monat_ab.datum%type,
        in_loa      in pzm_ze_pers_kst_monat_ab.lohnart%type
    );

end pzm_p_pers_zeit_kst;
/


-- sqlcl_snapshot {"hash":"b7a82a43388543f13cf8f8e5a79aba27c1ff52e2","type":"PACKAGE_SPEC","name":"PZM_P_PERS_ZEIT_KST","schemaName":"DIRKSPZM32","sxml":""}