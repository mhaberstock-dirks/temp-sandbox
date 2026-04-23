create or replace editionable trigger dirkspzm32.tr_isi_res_kosten_biud before
    insert or update or delete on dirkspzm32.isi_res_kosten
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
        :new.created_login_id := nvl(:new.created_login_id,
                                     -1);
    elsif updating then
        :new.last_change_date := sysdate;
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
end tr_lvs_inventur_job_kopf_biud;
/

alter trigger dirkspzm32.tr_isi_res_kosten_biud enable;


-- sqlcl_snapshot {"hash":"bf9730b48b8bef604b1d3dc9eb73cbbc5ea04449","type":"TRIGGER","name":"TR_ISI_RES_KOSTEN_BIUD","schemaName":"DIRKSPZM32","sxml":""}