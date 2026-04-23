create or replace editionable trigger dirkspzm32.tr_isi_res_mag_cfg_biud before
    insert or update or delete on dirkspzm32.isi_res_mag_cfg
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

alter trigger dirkspzm32.tr_isi_res_mag_cfg_biud enable;


-- sqlcl_snapshot {"hash":"f76502e4fab9a5dfc0cc94e85090263c04054f22","type":"TRIGGER","name":"TR_ISI_RES_MAG_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}