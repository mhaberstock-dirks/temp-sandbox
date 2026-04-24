create or replace procedure dirkspzm32.z_dir_pzm_delete_pdler_werksvertrag is
  -- Created on 06.01.2022 by DKROEKER
    v_personal pzm_personal%rowtype;
    v_del_date date;
    cursor c_personal is
    select
        *
    from
        pzm_personal t
    where
            t.pers_nr >= 80000
        and t.pers_nr <= 89999
    order by
        t.pers_nr;

begin
    open c_personal;
    loop
        fetch c_personal into v_personal;
        exit when c_personal%notfound;
        select
            max(t.ze_bde_day_ist_ende)
        into v_del_date
        from
            pzm_ze_bde_zeiten t
        where
                t.ze_bde_pers_nr = v_personal.pers_nr
            and t.ze_bde_day_ist_ende <= trunc(sysdate)
            and t.ze_bde_verbucht_status = 'UE';

        if v_del_date is null then
            select
                max(t.ze_bde_day_ist_ende)
            into v_del_date
            from
                pzm_ze_bde_zeiten t
            where
                t.ze_bde_pers_nr = v_personal.pers_nr;

            if v_del_date is null then
                v_del_date := trunc(sysdate) - 7;
            else
                v_del_date := null;
                v_del_date := trunc(sysdate) - 7;
            end if;

        end if;

        if v_del_date is not null then
            delete pzm_abwesenheits_antr t
            where
                    t.au_pers_nr = v_personal.pers_nr
                and t.au_ende <= v_del_date;

            delete pzm_abwesenheitsmeldungen t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.ende <= v_del_date;

            delete pzm_abwes_plan t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.abwes_plan_tag <= v_del_date;

            delete pzm_azubi_daten t
            where
                    t.ad_pers_nr = v_personal.pers_nr
                and t.ad_ausb_ende <= v_del_date;

            delete pzm_konten_bh t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.zk_start <= v_del_date;

            delete pzm_pers_lohn_zulagen t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.gueltig_datum_bis <= v_del_date;

            delete pzm_ze_azk_urlaub t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.datum <= v_del_date;

            delete pzm_ze_bde_zeiten t
            where
                    t.ze_bde_pers_nr = v_personal.pers_nr
                and t.ze_bde_day_ist_ende <= v_del_date
                and t.ze_bde_verbucht_status = 'UE';

            delete pzm_zeiterfassung t
            where
                    t.ze_pers_nr = v_personal.pers_nr
                and t.ze_calc_ist_ende <= v_del_date;

            delete pzm_konten_bh t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.zk_start <= v_del_date;

            update pzm_ze_loa_ausw t
            set
                t.aa_id = null
            where
                    t.zeaw_pers_nr = v_personal.pers_nr
                and t.zeaw_datum <= v_del_date;

            delete pzm_ze_loa_ausw t
            where
                    t.zeaw_pers_nr = v_personal.pers_nr
                and t.zeaw_datum <= v_del_date;

            delete pzm_ze_loa_exp_host t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.datum <= v_del_date;

            delete pzm_ze_loa_statistik_exp_host t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.datum <= v_del_date;

            delete pzm_ze_loa_13w_schnitt t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.datum <= v_del_date;

            delete pzm_ze_pers_kst_monat_ab t
            where
                    t.pers_nr = v_personal.pers_nr
                and t.datum <= v_del_date;

            delete pzm_ze_tagessatz t
            where
                    t.ts_pers_nr = v_personal.pers_nr
                and t.ts_day_wert_ende <= v_del_date;

            commit;
        end if;

    end loop;

    close c_personal;
end z_dir_pzm_delete_pdler_werksvertrag;
/


-- sqlcl_snapshot {"hash":"6a82b2c48ffbaa37ade2e6464886754c1888c5cf","type":"PROCEDURE","name":"Z_DIR_PZM_DELETE_PDLER_WERKSVERTRAG","schemaName":"DIRKSPZM32","sxml":""}