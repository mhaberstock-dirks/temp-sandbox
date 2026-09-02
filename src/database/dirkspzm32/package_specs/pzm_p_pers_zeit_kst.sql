create or replace 
package pzm_P_PERS_ZEIT_KST is

  -- Author  : HJGOEDEKE
  -- Created : 04.04.2011 13:55:40
  -- Purpose : Funktionen für die Zeitverteilung Presonal auf Resource

  -- Public function and procedure declarations
  procedure pzm_c_pd_pers_zeit_berech (in_sid                      in  pzm_ze_pers_kst_monat_ab.sid%type,
                                     in_firma_nr                 in  pzm_ze_pers_kst_monat_ab.firma_nr%type,
                                     in_datum                    in  pzm_ze_pers_kst_monat_ab.datum%type,
                                     in_loa                      in  pzm_ze_pers_kst_monat_ab.lohnart%type);

end pzm_P_PERS_ZEIT_KST;
/



-- sqlcl_snapshot {"hash":"66d8a0724b049d36d440893aca1da844f9dd43fb","type":"PACKAGE_SPEC","name":"PZM_P_PERS_ZEIT_KST","schemaName":"DIRKSPZM32","sxml":""}