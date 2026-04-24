create or replace editionable trigger dirkspzm32.tr_isi_res_prozess_data_biud before
    insert or update or delete on dirkspzm32.isi_res_prozess_data_cfg
    for each row
declare

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr   number;
    v_err_text varchar2(255);
begin
  -- Init Fehlervariablen
    v_err_nr := null;
    v_err_text := null;
    if inserting then
        :new.created_date := sysdate;
        if :new.id is null then
            :new.id := sys_guid();
        end if;

    elsif updating then
        :new.last_change_date := sysdate;
        if :new.id is null then
            :new.id := sys_guid();
        end if;

    end if;

exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
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
end;
/

alter trigger dirkspzm32.tr_isi_res_prozess_data_biud enable;


-- sqlcl_snapshot {"hash":"8aa88c3c83b2c0eb7689d30bfece7c79dead7553","type":"TRIGGER","name":"TR_ISI_RES_PROZESS_DATA_BIUD","schemaName":"DIRKSPZM32","sxml":""}