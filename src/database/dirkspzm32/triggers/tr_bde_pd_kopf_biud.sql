create or replace editionable trigger dirkspzm32.tr_bde_pd_kopf_biud before
    insert or update or delete on dirkspzm32.bde_pd_kopf
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr               number;
    v_err_text             varchar2(255);
    v_bde_pd_pers_zeit_kst bde_pd_pers_zeit_kst%rowtype;

  -- local variables here
begin
    if deleting then
        delete bde_pd_kopf_ma t
        where
                t.sid = :old.sid
            and t.firma_nr = :old.firma_nr
            and t.res_id = :old.res_id
            and t.pd_kopf_beginn = :old.pd_kopf_beginn;

    end if;

    if updating then
        update bde_pd_kopf_ma t
        set
            t.pd_kopf_ende = :new.pd_kopf_ende
        where
                t.sid = :new.sid
            and t.firma_nr = :new.firma_nr
            and t.res_id = :new.res_id
            and t.pd_kopf_beginn >= :new.pd_kopf_beginn - 1  -- -AG- 2019.10.18 - Falscher Filter
            and t.pd_kopf_ende is null;

    end if;

    if :new.pers_nr is null -- Keine PZM Bezug (Kostenstellenauswertung nicht möglich)

     then
        return;
    end if;
    if inserting then
        insert into bde_pd_kopf_ma values ( :new.sid,
                                            :new.firma_nr,
                                            :new.res_id,
                                            :new.ls_login_id,
                                            :new.pers_nr,
                                            :new.pd_kopf_beginn,
                                            null,
                                            :new.res_kst,
                                            :new.pers_kst,
                                            null,
                                            nvl(:new.ls_login_id,
                                                -1),
                                            null,
                                            null );

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

alter trigger dirkspzm32.tr_bde_pd_kopf_biud enable;


-- sqlcl_snapshot {"hash":"f04996d0759e900fe5765dc1ef73867068f28876","type":"TRIGGER","name":"TR_BDE_PD_KOPF_BIUD","schemaName":"DIRKSPZM32","sxml":""}