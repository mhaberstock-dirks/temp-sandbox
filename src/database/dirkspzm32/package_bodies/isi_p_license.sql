create or replace 
package body DIRKSPZM32.isi_p_license is
  -- Initialisierung
  c_c constant varchar2(200)   := 'AAJqi2pnka5IfEmpfsAL/Q==';
  c_mba constant varchar2(200) := 'dGwJf4iFj8ULejfIq+WMGQ==';
  v_srv varchar2(200);

  c_license_type_app_count constant varchar2(40) := 'APP-COUNT';
  c_license_firma_cfg_type constant varchar2(10) := 'LIC';

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(255);
  -------------------------------------------------------------------------------------------------------

  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

  function check_license_key_valid(in_isi_firma_cfg isi_firma_cfg%rowtype) return varchar2 is
    v_result varchar2(1);
    v_key_fields varchar2(4000);
    v_key varchar2(4000);
  begin
    v_result := c.c_false;
    v_key_fields :=  in_isi_firma_cfg.sid ||
                     in_isi_firma_cfg.firma_nr ||
                     in_isi_firma_cfg.kategorie ||
                     in_isi_firma_cfg.parameter_name ||
                     in_isi_firma_cfg.parameter_wert;

    v_key := isi_utils.md5_encrypt(v_key_fields || c_c);
    if v_key = in_isi_firma_cfg.license_key
    then
      v_result := c.c_true;
    else
      v_key := isi_utils.md5_encrypt(v_key_fields || c_mba);
      if v_key = in_isi_firma_cfg.license_key
      then
        v_result := c.c_true;
      else
        v_key := isi_utils.md5_encrypt(v_key_fields || v_srv);
        if v_key = in_isi_firma_cfg.license_key
        then
          v_result := c.c_true;
        end if;
      end if;
    end if;

    return v_result;
  end;

  procedure c_update_system_info(in_sid in isi_sid.sid%type,
                                 in_firma_nr in isi_firma.firma_nr%type,
                                 in_app_exe_filename in varchar2,
                                 in_hostname in varchar2,
                                 in_os_username in varchar2,
                                 in_license_ts in date,
                                 in_license_valid_sek in number,
                                 in_license_ticket_id in number) is

    v_system_info isi_system_info%rowtype;

    cursor c_system_info is
      select *
        from isi_system_info si
       where si.sid = in_sid
         and si.firma_nr = in_firma_nr
         and si.appl_exe_name = upper(in_app_exe_filename)
         and si.hostname = upper(in_hostname)
         and si.last_run_os_user = upper(in_os_username);
  begin
    open c_system_info;

    fetch c_system_info into v_system_info;
    if c_system_info%found
    then
      update isi_system_info si
         set si.last_license_ticket_ts = in_license_ts,
             si.last_license_valid_sek = in_license_valid_sek,
             si.last_license_ticket_id = in_license_ticket_id,
             si.status = 'run'
       where si.sid = in_sid
         and si.firma_nr = in_firma_nr
         and si.appl_exe_name = upper(in_app_exe_filename)
         and si.hostname = upper(in_hostname)
         and si.last_run_os_user = upper(in_os_username);
    else
      insert into isi_system_info (
        sid,
        firma_nr,
        hostname,
        appl_exe_name,
        last_run_os_user,
        last_license_ticket_id,
        last_license_ticket_ts,
        last_license_valid_sek,
        status
      ) values (
        in_sid,
        in_firma_nr,
        upper(in_hostname),
        upper(in_app_exe_filename),
        upper(in_os_username),
        in_license_ticket_id,
        in_license_ts,
        in_license_valid_sek,
        'run'
      );
    end if;

    close c_system_info;

    commit;
  end;

  procedure get_app_license_ticket(in_sid in isi_sid.sid%type,
                                   in_firma_nr in isi_firma.firma_nr%type,
                                   in_license_type in varchar2,
                                   in_app_exe_filename in varchar2,
                                   in_hostname in varchar2,
                                   in_os_username in varchar2,
                                   out_license_ts out date,
                                   out_license_valid_sek out number,
                                   out_license_ticket_id out number
                                  ) is
    v_isi_firma_cfg isi_firma_cfg%rowtype;

    v_valid_apps_running number;
    v_max_app_count number;

    cursor c_isi_firma_cfg is
      select *
        from isi_firma_cfg t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.kategorie = in_license_type
         and t.parameter_name = upper(in_app_exe_filename)
         and t.typ = c_license_firma_cfg_type;

    cursor c_valid_apps_running is
      select count(*)
        from isi_system_info si
       where si.sid = in_sid
         and si.firma_nr = in_firma_nr
         and si.appl_exe_name = upper(in_app_exe_filename)
         and (si.hostname || si.last_run_os_user) != (upper(in_hostname) || upper(in_os_username))
         and si.status = 'run'
         and si.last_license_ticket_ts > sysdate - ((out_license_valid_sek / 60 / 60 / 24) * 2);

    v_last_semicolon_pos number;
    v_next_semicolon_pos number;
    v_gleich_pos number;
    v_param_value isi_firma_cfg.parameter_wert%type;
    v_param isi_firma_cfg.parameter_wert%type;
    v_value isi_firma_cfg.parameter_wert%type;

    v_license_valid boolean;
  begin
    if in_license_type not in (c_license_type_app_count)
    then
      raise_application_error(-20000, 'Invalid Licensetype: ' || in_license_type);
    end if;

    out_license_ticket_id := -1;
    v_license_valid := false;
    v_max_app_count := null;
    out_license_valid_sek := 60;

    open c_isi_firma_cfg;

    fetch c_isi_firma_cfg into v_isi_firma_cfg;

    if c_isi_firma_cfg%found
    then
      if check_license_key_valid(v_isi_firma_cfg) = c.c_true
      then
        if in_license_type = c_license_type_app_count
        then
          v_valid_apps_running := 0;
          open c_valid_apps_running;
          fetch c_valid_apps_running into v_valid_apps_running;
          close c_valid_apps_running;

          v_last_semicolon_pos := 1;
          loop
            v_next_semicolon_pos := instr(v_isi_firma_cfg.parameter_wert, ';', v_last_semicolon_pos);
            exit when v_next_semicolon_pos = 0;

            v_param_value := substr(v_isi_firma_cfg.parameter_wert, v_last_semicolon_pos, v_next_semicolon_pos - v_last_semicolon_pos);
            v_last_semicolon_pos := v_next_semicolon_pos + 1;

            v_gleich_pos := instr(v_param_value, '=');
            if v_gleich_pos = 0
            then
              v_param := v_param_value;
              v_value := null;
            else
              v_param := substr(v_param_value, 1, v_gleich_pos - 1);
              v_value := substr(v_param_value, v_gleich_pos + 1);
            end if;

            if v_value is not null
            then
              if lower(v_param) = 'int-max-app-count'
              then
                v_max_app_count := to_number(v_value);
              elsif lower(v_param) = 'int-lic-valid-sek'
              then
                out_license_valid_sek := to_number(v_value);
              end if;
            end if;
          end loop;

          if v_max_app_count is null
          then
            -- Keine Lizenzierung installiert
            v_license_valid := true;
          else
            v_license_valid := (v_max_app_count - v_valid_apps_running) > 0;
          end if;

          if v_license_valid
          then
            select seq_license_ticket_id.nextval into out_license_ticket_id from dual;
            out_license_ts := sysdate;
            c_update_system_info(in_sid,
                                 in_firma_nr,
                                 in_app_exe_filename,
                                 in_hostname,
                                 in_os_username,
                                 out_license_ts,
                                 out_license_valid_sek,
                                 out_license_ticket_id);
          end if;
        end if;
      else
        raise_application_error(-20001, '	License configuration is modified');
      end if;
    end if;

    close c_isi_firma_cfg;
  end;
begin
  SELECT lpad(to_char(t.DBID), 11, '0') || 'LejfIq+WMGQ==' into v_srv FROM sys.V_$DATABASE t;
end isi_p_license;
/



-- sqlcl_snapshot {"hash":"f299df0b20908c74a63d74422c67a9ae2abcb39b","type":"PACKAGE_BODY","name":"ISI_P_LICENSE","schemaName":"DIRKSPZM32","sxml":""}