create or replace function dirkspzm32.bde_c_pd_lte_insert
/*
  Traegt eine LTE ein.
  Es wird die Funktion BDE_PD_LTE_INSERT aufgerufen und anschließend ein Commit durchgefuehrt.
  ---- HISTORY ---
  21.10.2013 -MM- Kommentare in JavaDoc-Style geändert
  @param in_sid 
  @param in_res_id Ressourcen-ID
  @param in_ls_login_id Login ID aktueller User
  @param in_lte_name 
  @return 
*/ (
    in_sid         in isi_sid.sid%type,
    in_res_id      in isi_resource.res_id%type,
    in_ls_login_id in isi_user.login_id%type,
    in_lte_name    in lvs_lte_cfg.lte_name%type
) return varchar2 is
    v_result   lvs_lte.lte_id%type;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerfelder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
begin
    v_result := bde_pd_lte_insert(in_sid, in_res_id, in_ls_login_id, in_lte_name);
    commit;
    return ( v_result );
exception
  -- Im Fehlerfall ist der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
    when v_error then  -- Update 2011 show Exception Source Line
        rollback;
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
        rollback;
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;

end bde_c_pd_lte_insert;
/


-- sqlcl_snapshot {"hash":"6c1a3799b0586f19789d33ca78acf69037f00723","type":"FUNCTION","name":"BDE_C_PD_LTE_INSERT","schemaName":"DIRKSPZM32","sxml":""}