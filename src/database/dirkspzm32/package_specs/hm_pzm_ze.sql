create or replace package dirkspzm32.hm_pzm_ze is
    procedure update_pers_ze_tag (
        p_pers_nr  in number,
        p_datum    in date,
        p_result   out number,
        p_res_info out varchar2,
        p_zaehler  number default 0
    );

end hm_pzm_ze;
/


-- sqlcl_snapshot {"hash":"48f788f8d7710cf2de5fa8d09150cc53de666b3e","type":"PACKAGE_SPEC","name":"HM_PZM_ZE","schemaName":"DIRKSPZM32","sxml":""}