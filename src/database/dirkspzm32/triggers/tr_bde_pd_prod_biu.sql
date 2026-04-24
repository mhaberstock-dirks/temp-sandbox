create or replace editionable trigger dirkspzm32.tr_bde_pd_prod_biu before
    insert or update on dirkspzm32.bde_pd_prod
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr         number;
    v_err_text       varchar2(255);
    v_bde_fa_auftrag bde_fa_auftrag%rowtype;
begin
    if
        :new.vorg_typ = 'PP'
        and bde_p_base.get_fa_ag(:new.sid,
                                 :new.firma_nr,
                                 :new.leitzahl,
                                 :new.fa_ag,
                                 :new.fa_upos,
                                 v_bde_fa_auftrag)
    then
        if v_bde_fa_auftrag.freig_status = 'N'     -- Auftrag nicht angemeldet. Man. Eingabe dann Auftrag Status auf Produktion und Startzeit eintragen.
         then
            update bde_fa_auftrag t
            set
                t.termin_start_ist = :new.prod_beginn,
                t.freig_status = 'TF'
            where
                    t.sid = :new.sid
                and t.firma_nr = :new.firma_nr
                and t.leitzahl = :new.leitzahl
                and t.fa_ag = :new.fa_ag
                and t.fa_upos = :new.fa_upos;

        end if;

        if v_bde_fa_auftrag.anz_res = 0     -- Auftrag nicht angemeldet. Man. Eingabe dann Auftrag Status auf Produktion und Startzeit eintragen.

         then
            update bde_fa_auftrag t
            set
                t.freig_status =
                    case
                        when :new.menge_a + v_bde_fa_auftrag.ag_ist_mg >= v_bde_fa_auftrag.ag_soll_mg then
                            'F'
                        else
                            t.freig_status
                    end
            where
                    t.sid = :new.sid
                and t.firma_nr = :new.firma_nr
                and t.leitzahl = :new.leitzahl
                and t.fa_ag = :new.fa_ag
                and t.fa_upos = :new.fa_upos;

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
end tr_bde_pd_prod_biu;
/

alter trigger dirkspzm32.tr_bde_pd_prod_biu enable;


-- sqlcl_snapshot {"hash":"a6af13aaaedad1c42c13b3dfc0a24fa27e297067","type":"TRIGGER","name":"TR_BDE_PD_PROD_BIU","schemaName":"DIRKSPZM32","sxml":""}