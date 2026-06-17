create or replace 
function DIRKSPZM32.get_security_cfg_user_param(in_sid in isi_security_cfg.sid%type,
                                                       in_firma_nr in isi_security_cfg.firma_nr%type,
                                                       in_login_id in isi_user.login_id%type,
                                                       in_module_name in isi_security_cfg.module_name%type,
                                                       in_kategorie in isi_security_cfg.kategorie%type,
                                                       in_param_name in isi_security_cfg.parameter_name%type,
                                                       in_default_wert in isi_security_cfg.parameter_wert%type default null)
                                                       return isi_security_cfg.parameter_wert%type is
  v_result isi_security_cfg.parameter_wert%type;
  v_group_id isi_security_cfg.group_id%type;

  v_security_cfg isi_security_cfg%rowtype;

  cursor c_user is
    select group_id
      from sec_user_groups ug
     where ug.sid = in_sid
       and ug.firma_nr = in_firma_nr
       and ug.login_id = in_login_id;

  cursor c_security_cfg is
    select *
      from isi_security_cfg t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.group_id = v_group_id
       and t.module_name = in_module_name
       and t.kategorie = in_kategorie
       and t.parameter_name = in_param_name;
begin
  v_result := in_default_wert;

  open c_user;

  fetch c_user into v_group_id;
  if c_user%found
  then
    open c_security_cfg;

    fetch c_security_cfg into v_security_cfg;
    if c_security_cfg%found
    then
      v_result := v_security_cfg.parameter_wert;
    end if;

    close c_security_cfg;
  end if;

  close c_user;

  return(v_result);
end;
/



-- sqlcl_snapshot {"hash":"d5141e0751e9287f4b48ead49b98e1957bd81921","type":"FUNCTION","name":"GET_SECURITY_CFG_USER_PARAM","schemaName":"DIRKSPZM32","sxml":""}