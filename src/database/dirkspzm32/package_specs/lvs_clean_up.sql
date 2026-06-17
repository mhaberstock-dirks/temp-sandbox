create or replace 
package DIRKSPZM32.LVS_CLEAN_UP is

  -- Author  : BWELLING
  -- Created : 21.11.2022 15:22:50
  -- Purpose : Lagerplaetze, Transporte Bereinigen

  -- Public type declarations
  function lvs_lgr_clean (in_error_id in number,
                          in_lgr_platz in lvs_lgr.lgr_platz%type,
                          in_transp_id in isi_transport.transp_id%type,
                          out_text out varchar2) return varchar2;

  function lvs_clean_all return varchar2;


end LVS_CLEAN_UP;
/



-- sqlcl_snapshot {"hash":"9a0a76ccdfb9794b506c2c3faa745775927b5fb3","type":"PACKAGE_SPEC","name":"LVS_CLEAN_UP","schemaName":"DIRKSPZM32","sxml":""}