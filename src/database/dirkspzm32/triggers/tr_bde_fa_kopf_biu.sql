create or replace editionable trigger dirkspzm32.tr_bde_fa_kopf_biu before
    insert or update on dirkspzm32.bde_fa_kopf
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
  --:new.fa_nr := round(:new.fa_nr, 0);

    if updating then
        if
            :old.status = 'N'
            and :new.status != 'N'
        then
            update pps_plan_auftrag t
            set
                t.status = 'B'
            where
                    t.sid = :new.sid
                and t.firma_nr = :new.firma_nr
                and t.plan_auf_id = :new.fa_nr
                and ( t.status = 'UBDE'
                      or t.status = 'N'
                      or t.status = 'T' );

        end if;

        if :new.status = 'F' then
            update pps_plan_auftrag t
            set
                t.status = 'F'
            where
                    t.sid = :new.sid
                and t.firma_nr = :new.firma_nr
                and t.plan_auf_id = :new.fa_nr
                and t.status != 'FH';

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
end tr_bde_fa_auftrag_biu;
/

alter trigger dirkspzm32.tr_bde_fa_kopf_biu enable;


-- sqlcl_snapshot {"hash":"a5aed2ee709c9c1cd9cc5bc612342eba342ec133","type":"TRIGGER","name":"TR_BDE_FA_KOPF_BIU","schemaName":"DIRKSPZM32","sxml":""}