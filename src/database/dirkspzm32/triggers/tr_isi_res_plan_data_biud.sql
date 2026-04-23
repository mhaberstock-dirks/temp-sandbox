create or replace editionable trigger dirkspzm32.tr_isi_res_plan_data_biud before
    insert or update or delete on dirkspzm32.isi_res_plan_data
    for each row
declare

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr   number;
    v_err_text varchar2(255);
    v_res      isi_resource%rowtype;
begin
  -- Init Fehlervariablen
    v_err_nr := null;
    v_err_text := null;
    if inserting then
        if :new.sm_name is null then
            if not isi_p_base.get_resource(:new.sid,
                                           :new.res_id,
                                           v_res) then
                v_err_nr := 10;
                v_err_text := lc.ec_p1(lc.o_tp1_resource_fehlt,
                                       to_char(:new.res_id));

                raise v_error;
            end if;

            :new.arbeitszeitmodellnr := 'R' || v_res.res_name;
        end if;

        :new.created_date := sysdate;
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

alter trigger dirkspzm32.tr_isi_res_plan_data_biud enable;


-- sqlcl_snapshot {"hash":"69e43054fa3b16499ae30bb99cd878678397f17d","type":"TRIGGER","name":"TR_ISI_RES_PLAN_DATA_BIUD","schemaName":"DIRKSPZM32","sxml":""}