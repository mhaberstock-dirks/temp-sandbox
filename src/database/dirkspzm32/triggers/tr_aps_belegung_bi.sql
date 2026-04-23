create or replace editionable trigger dirkspzm32.tr_aps_belegung_bi before
    insert on dirkspzm32.aps_belegung
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);
begin
    if :new.ressourcentyp = 1           -- Typ Maschine
     then
        update aps_fa_vorgangs_position t
        set
            t.plan_res_name = :new.ressourcennr
        where
                t.fakopfnr = :new.fakopfnr
            and t.favorgangsnr = :new.favorgangsnr
            and nvl(t.favorgangsalternative, -1) = nvl(:new.favorgangsalternative,
                                                       -1)
            and t.favorgangssplittnr = :new.favorgangssplittnr
            and t.plan_res_name is null;

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

alter trigger dirkspzm32.tr_aps_belegung_bi enable;


-- sqlcl_snapshot {"hash":"1ea78a26fb9e44334e73beb7bf83d1680b34dd34","type":"TRIGGER","name":"TR_APS_BELEGUNG_BI","schemaName":"DIRKSPZM32","sxml":""}