create or replace editionable trigger dirkspzm32.tr_isi_res_fhm_biud before
    insert or update on dirkspzm32.isi_res_fhm
    for each row
declare
  -- local variables here
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler-Variablen für eine Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
begin
  -- Erst mal kein Fehler
    v_err_nr := null;
    v_err_text := null;
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        if :new.created_login_id is null then
            :new.created_login_id := -1;
        end if;

    elsif updating then
        if :new.last_change_date = :old.last_change_date
        or :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;
    elsif deleting then
        delete isi_res_fhm_list t
        where
            t.fhm = :old.fhm;

        null;
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
end tr_isi_res_fhm_biud;
/

alter trigger dirkspzm32.tr_isi_res_fhm_biud enable;


-- sqlcl_snapshot {"hash":"4a72c0187bce095295388228c6a86d07cc4f424b","type":"TRIGGER","name":"TR_ISI_RES_FHM_BIUD","schemaName":"DIRKSPZM32","sxml":""}