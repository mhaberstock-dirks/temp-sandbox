create or replace editionable trigger dirkspzm32.tr_isi_order_tour_bd before
    delete on dirkspzm32.isi_order_tour
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
begin
    delete isi_order_pos t
    where
        t.vorgang_id = :old.vorgang_id;

    delete isi_order_kopf t
    where
        t.vorgang_id = :old.vorgang_id;

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
end tr_isi_order_kopf_bd;
/

alter trigger dirkspzm32.tr_isi_order_tour_bd enable;


-- sqlcl_snapshot {"hash":"604053a71e661f75da98e54ea5f09df6fb8c3330","type":"TRIGGER","name":"TR_ISI_ORDER_TOUR_BD","schemaName":"DIRKSPZM32","sxml":""}