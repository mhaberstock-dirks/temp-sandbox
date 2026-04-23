create or replace editionable trigger dirkspzm32.tr_lvs_lam_biu before
    insert or update on dirkspzm32.lvs_lam
    for each row
declare
  -- local variables here
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
begin
    if
        :new.akt_inventur_id is not null
        and :new.order_pos_auf_id is not null
    then
        v_err_text := 'Fehler: Eine Inventur und die Reservierung für LHM: '
                      || :new.lhm_id
                      || ' kann nicht gleichzeitig geschaltet werden.';
        v_err_nr := 10;
        raise v_error;
    end if;

    :new.lam_mhd := trunc(:new.lam_mhd);
    :new.lam_mhd_ausgabe := trunc(:new.lam_mhd_ausgabe);
    if :new.hersteller_kuerzel_liste = ';' then
        :new.hersteller_kuerzel_liste := null;
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
end tr_lvs_lam_bd;
/

alter trigger dirkspzm32.tr_lvs_lam_biu enable;


-- sqlcl_snapshot {"hash":"a1fa124abf9e7bbaac2cb8c5493a1f57484a7007","type":"TRIGGER","name":"TR_LVS_LAM_BIU","schemaName":"DIRKSPZM32","sxml":""}