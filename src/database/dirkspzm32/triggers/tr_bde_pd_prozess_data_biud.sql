create or replace editionable trigger dirkspzm32.tr_bde_pd_prozess_data_biud before
    insert or update or delete on dirkspzm32.bde_pd_prozess_data
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
        if :new.res_prozess_data_date is null then
            :new.res_prozess_data_date := sysdate;
        end if;

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

alter trigger dirkspzm32.tr_bde_pd_prozess_data_biud enable;


-- sqlcl_snapshot {"hash":"5fee2620d5eee195573e84625490c264a6504732","type":"TRIGGER","name":"TR_BDE_PD_PROZESS_DATA_BIUD","schemaName":"DIRKSPZM32","sxml":""}