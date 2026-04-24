create or replace editionable trigger dirkspzm32.tr_bde_pd_pers_zeit_kst_buid before
    insert or update or delete on dirkspzm32.bde_pd_pers_zeit_kst
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
    if not deleting then
        if :new.pd_pers_ende != to_date ( '31.12.3000',
        'dd.mm.yyyy' ) then
            :new.pd_pers_zeit_min := ( :new.pd_pers_ende - :new.pd_pers_beginn ) * 1440;

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

alter trigger dirkspzm32.tr_bde_pd_pers_zeit_kst_buid enable;


-- sqlcl_snapshot {"hash":"be33acc082b649d4a808d4175502ae7e97a00846","type":"TRIGGER","name":"TR_BDE_PD_PERS_ZEIT_KST_BUID","schemaName":"DIRKSPZM32","sxml":""}