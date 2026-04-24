create or replace editionable trigger dirkspzm32.tr_isi_currency_biud before
    insert or update or delete on dirkspzm32.isi_currency
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
    if inserting
    or updating then
        if :new.base_currency is null then
            select
                t.waehrung
            into :new.base_currency
            from
                isi_adressen t
            where
                    t.sid = :new.sid
                and t.firma_nr = :new.firma_nr
                and t.adr_art = 'E'
                and t.adr_nr = :new.firma_nr
                and t.adr_liefer = '0';

        end if;

        if :new.currency is null then
            select
                t.waehrung
            into :new.currency
            from
                isi_adressen t
            where
                    t.sid = :new.sid
                and t.firma_nr = :new.firma_nr
                and t.adr_art = 'E'
                and t.adr_nr = :new.firma_nr
                and t.adr_liefer = '0';

        end if;

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

alter trigger dirkspzm32.tr_isi_currency_biud enable;


-- sqlcl_snapshot {"hash":"ae8a841b9ad4c8b7d2e27d290bcff7a971a697a6","type":"TRIGGER","name":"TR_ISI_CURRENCY_BIUD","schemaName":"DIRKSPZM32","sxml":""}