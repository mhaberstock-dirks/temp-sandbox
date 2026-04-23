create or replace package dirkspzm32.lvs_clean_up is

  -- Author  : BWELLING
  -- Created : 21.11.2022 15:22:50
  -- Purpose : Lagerplaetze, Transporte Bereinigen

  -- Public type declarations
    function lvs_lgr_clean (
        in_error_id  in number,
        in_lgr_platz in lvs_lgr.lgr_platz%type,
        in_transp_id in isi_transport.transp_id%type,
        out_text     out varchar2
    ) return varchar2;

    function lvs_clean_all return varchar2;

end lvs_clean_up;
/


-- sqlcl_snapshot {"hash":"f0f1597c3e527b55f258fd38f0ec76018bc0d374","type":"PACKAGE_SPEC","name":"LVS_CLEAN_UP","schemaName":"DIRKSPZM32","sxml":""}