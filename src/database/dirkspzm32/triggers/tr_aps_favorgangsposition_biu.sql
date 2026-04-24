create or replace editionable trigger dirkspzm32.tr_aps_favorgangsposition_biu before
    insert or update on dirkspzm32.aps_fa_vorgangs_position
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr                number;
    v_err_text              varchar2(255);
    v_fa                    bde_fa_auftrag%rowtype;
    v_res                   isi_resource%rowtype;
    v_res_fa                isi_resource%rowtype;
    v_dauerstabilerzeitraum aps_planparameter.dauerstabilerzeitraum%type;
    cursor c_res_fa is
    select
        r.*
    from
        bde_fa_auftrag_res_liste t,
        isi_resource             r
    where
            t.sid = v_fa.sid
        and t.firma_nr = v_fa.firma_nr
        and t.leitzahl = v_fa.leitzahl
        and t.fa_ag = v_fa.fa_ag
        and t.fa_upos = v_fa.fa_upos
        and t.res_id = r.res_id
        and r.typ = 'MPG';              -- Produktionsgruppe soll produzieren
    cursor c_planparam is
    select
        max(t.dauerstabilerzeitraum)
    from
        aps_planparameter t;

begin
    if updating then
        if :new.fixiert != :old.fixiert  -- wird aus ISI geändert
         then
            return;
        end if;
    end if;

    if bde_p_base.get_fa_ag(null,
                            null,
                            to_number(substr(:new.fakopfnr,
                                             3)),
                            to_number(:new.favorgangsnr),
                            :new.favorgangssplittnr,
                            v_fa) then
        if ( (
            :new.typ = 2
            and v_fa.satzart = 'VR'
        )                      -- Rüsten nur beim Rüsten eintragen
        or (
            :new.typ = 1
            and v_fa.satzart = 'V'
        )                       -- Fertigen nur beim Fertigen eintragen
         ) then
            v_res := null;
            v_res_fa := null;
            open c_res_fa;
            fetch c_res_fa into v_res_fa;
            close c_res_fa;
            if v_res_fa.res_id is not null
               or (
                :new.plan_res_name is not null
                and isi_p_base.get_resource_by_name(:new.plan_res_name,
                                                    v_res)
            ) then
                open c_planparam;
                fetch c_planparam into v_dauerstabilerzeitraum;
                close c_planparam;
                if sysdate + v_dauerstabilerzeitraum > to_date ( :new.planstart,
                'yyyymmdd hh24:mi:ss' )
                or isi_allg.c_get_firma_cfg_param(v_fa.sid, v_fa.firma_nr, 'APS_ERP',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
                 null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                 'ERP_FIX_MS',          -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                  'APS',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                   'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                   c.c_true,              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                   'BOOLEAN') = c.c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                                   then
                    update bde_fa_auftrag fa
                    set
                        fa.res_id = nvl(v_res_fa.res_id, v_res.res_id),
                        fa.termin_start_gepl = to_date(:new.planstart, 'yyyymmdd hh24:mi:ss'),
                        fa.termin_ende_gepl = to_date(:new.planende, 'yyyymmdd hh24:mi:ss')
                    where
                            fa.sid = v_fa.sid
                        and fa.firma_nr = v_fa.firma_nr
                        and fa.leitzahl = v_fa.leitzahl
                        and fa.fa_ag = v_fa.fa_ag
                        and fa.fa_upos = v_fa.fa_upos
                        and nvl(fa.ab_ende_status, 'R') != 'P';

                else
                    update bde_fa_auftrag fa
                    set
                        fa.termin_start_gepl = to_date(:new.planstart, 'yyyymmdd hh24:mi:ss'),
                        fa.termin_ende_gepl = to_date(:new.planende, 'yyyymmdd hh24:mi:ss')
                    where
                            fa.sid = v_fa.sid
                        and fa.firma_nr = v_fa.firma_nr
                        and fa.leitzahl = v_fa.leitzahl
                        and fa.fa_ag = v_fa.fa_ag
                        and fa.fa_upos = v_fa.fa_upos
                        and nvl(fa.ab_ende_status, 'R') != 'P';

                end if;

                if :new.status = 32                  -- Ganttpaan glaubt der Auftrag ist fertig

                 then
                    if v_fa.freig_status = 'TF'        -- Auftrag ist aber erst Teilfertig
                     then                               -- Maschine aus dem FA löschen, damit der FA erst nach erneuter Planung angemeldet werden kann
                                             -- oder Maschinengruppe eingetragen lassen
                        update bde_fa_auftrag fa
                        set
                            fa.res_id = v_res_fa.res_id
                        where
                                fa.sid = v_fa.sid
                            and fa.firma_nr = v_fa.firma_nr
                            and fa.leitzahl = v_fa.leitzahl
                            and fa.fa_ag = v_fa.fa_ag
                            and fa.fa_upos = v_fa.fa_upos;
            --:new.letzterueckmeldung := to_char(sysdate, 'yyyymmdd hh24:mi:ss');
            --:new.status := 64;
            --:new.statusbeschreibung := 'unterbrochen';
            --:new.bruttomenge := v_fa.ag_soll_mg - v_fa.ag_ist_mg;
            --:new.nettomenge := v_fa.ag_soll_mg - v_fa.ag_ist_mg;
                    end if;
                end if;

            end if;

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

alter trigger dirkspzm32.tr_aps_favorgangsposition_biu enable;


-- sqlcl_snapshot {"hash":"7bbd6c0bbdbf5bd37bc7db54d76eb0366515a18a","type":"TRIGGER","name":"TR_APS_FAVORGANGSPOSITION_BIU","schemaName":"DIRKSPZM32","sxml":""}