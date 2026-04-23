create or replace editionable trigger dirkspzm32.tr_bde_fa_kopf_bd before
    delete on dirkspzm32.bde_fa_kopf
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

  -- local variables here
begin
    delete bde_fa_auftrag t
    where
            t.sid = :old.sid
        and t.firma_nr = :old.firma_nr
        and t.leitzahl = :old.fa_nr;

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
end tr_bde_fa_auftrag_bd;
/

alter trigger dirkspzm32.tr_bde_fa_kopf_bd enable;


-- sqlcl_snapshot {"hash":"65ba313e32a3477928eab3fe535b6aea36688cef","type":"TRIGGER","name":"TR_BDE_FA_KOPF_BD","schemaName":"DIRKSPZM32","sxml":""}