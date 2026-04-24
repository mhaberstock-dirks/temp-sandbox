create or replace editionable trigger dirkspzm32.tr_aps_ergebnisinfo_biu before
    insert or update on dirkspzm32.aps_ergebnisinfo
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
begin
    if inserting then
        :new.erstelltam := sysdate;
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
end tr_aps_ergebnisinfo_biu;
/

alter trigger dirkspzm32.tr_aps_ergebnisinfo_biu enable;


-- sqlcl_snapshot {"hash":"513ebd225cfacac490ae39ff878500e2c3a913e2","type":"TRIGGER","name":"TR_APS_ERGEBNISINFO_BIU","schemaName":"DIRKSPZM32","sxml":""}