create or replace function dirkspzm32.get_security_cfg_grp_param (
    in_sid          in isi_security_cfg.sid%type,
    in_firma_nr     in isi_security_cfg.firma_nr%type,
    in_group_id     in isi_security_cfg.group_id%type,
    in_module_name  in isi_security_cfg.module_name%type,
    in_kategorie    in isi_security_cfg.kategorie%type,
    in_param_name   in isi_security_cfg.parameter_name%type,
    in_default_wert in isi_security_cfg.parameter_wert%type default null
) return isi_security_cfg.parameter_wert%type is

    v_result       isi_security_cfg.parameter_wert%type;
    v_security_cfg isi_security_cfg%rowtype;
    cursor c_security_cfg is
    select
        *
    from
        isi_security_cfg t
    where
            t.sid = in_sid
        and t.firma_nr = in_firma_nr
        and t.group_id = in_group_id
        and t.module_name = in_module_name
        and t.kategorie = in_kategorie
        and t.parameter_name = in_param_name;

begin
    v_result := in_default_wert;
    open c_security_cfg;
    fetch c_security_cfg into v_security_cfg;
    if c_security_cfg%found then
        v_result := v_security_cfg.parameter_wert;
    end if;
    close c_security_cfg;
    return ( v_result );
end;
/


-- sqlcl_snapshot {"hash":"fadd77bdda234c75f5fc9c2f692adcc908692a49","type":"FUNCTION","name":"GET_SECURITY_CFG_GRP_PARAM","schemaName":"DIRKSPZM32","sxml":""}