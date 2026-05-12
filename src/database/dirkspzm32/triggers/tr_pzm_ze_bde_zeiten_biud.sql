create or replace editionable trigger dirkspzm32.tr_pzm_ze_bde_zeiten_biud before
    insert or update or delete on dirkspzm32.pzm_ze_bde_zeiten
    for each row
declare
    v_tagessatz       pzm_ze_tagessatz%rowtype;
    cursor c_tagessatz is
    select
        *
    from
        pzm_ze_tagessatz t
    where
            t.ts_pers_nr = :new.ze_bde_pers_nr
        and t.ts_datum = :new.ze_bde_datum;

    v_ze_bde_zeit_min number;
begin
    if ( inserting
    or updating ) then
        if :new.ze_bde_zeit_min is null then
            open c_tagessatz;
            fetch c_tagessatz into v_tagessatz;
            close c_tagessatz;
            v_ze_bde_zeit_min := ( ( ( :new.ze_bde_day_ist_ende - :new.ze_bde_day_ist_start ) * 1440 ) ) * ( v_tagessatz.ts_day_arb_std
            + v_tagessatz.ts_day_flex_std + v_tagessatz.ts_day_ueb_std ) / ( ( v_tagessatz.ts_day_wert_ende - v_tagessatz.ts_day_wert_start
            ) * 24 - ( v_tagessatz.ts_day_abw_std ) );

            :new.ze_bde_zeit_min := round(v_ze_bde_zeit_min, 3);
        end if;
    end if;

    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        if :new.created_login_id is null then
            :new.created_login_id := current_isi_user_login_id();
        end if;

    end if;

    if updating then
        if :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        if :new.last_change_login_id is null then
            :new.last_change_login_id := current_isi_user_login_id();
        end if;

        begin
      -- Die im ERP verbuchten Zeiten in den Fertigungsauftrag übernehmen
            if
                :new.ze_bde_verbucht_status = 'UE'
                and :new.ze_bde_verbucht_status != :old.ze_bde_verbucht_status
            then
                :new.ze_bde_dwh_status := 'N';
                update bde_fa_auftrag t
                set
                    t.prod_zeit_ist = t.prod_zeit_ist + :new.ze_bde_zeit_min
                where
                        t.leitzahl = :new.ze_bde_leitzahl
                    and t.fa_ag = :new.ze_bde_fa_ag
                    and t.fa_upos = :new.ze_bde_fa_upos;

            end if;

            if
                :old.ze_bde_verbucht_status = 'UE'
                and :new.ze_bde_verbucht_status != :old.ze_bde_verbucht_status
            then
                :new.ze_bde_dwh_status := 'N';
                update bde_fa_auftrag t
                set
                    t.prod_zeit_ist = t.prod_zeit_ist - :old.ze_bde_zeit_min
                where
                        t.leitzahl = :old.ze_bde_leitzahl
                    and t.fa_ag = :old.ze_bde_fa_ag
                    and t.fa_upos = :old.ze_bde_fa_upos;

            end if;

        exception
            when others then
                null;     -- FA im BDE nicht zu buchen ignorieren
        end;

    end if;

end;
/

alter trigger dirkspzm32.tr_pzm_ze_bde_zeiten_biud enable;


-- sqlcl_snapshot {"hash":"b0f03744ffee46749e8d384762d1b63e4bd89ace","type":"TRIGGER","name":"TR_PZM_ZE_BDE_ZEITEN_BIUD","schemaName":"DIRKSPZM32","sxml":""}