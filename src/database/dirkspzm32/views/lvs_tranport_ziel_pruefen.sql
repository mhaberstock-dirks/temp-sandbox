create or replace force editionable view dirkspzm32.lvs_tranport_ziel_pruefen (
    res_name_list,
    anz_transporte,
    max_transporte,
    max_belegung
) as
    select
        r.res_name
        || ';'
        || (
            select
                stradd_distinct(rl.res_name)
            from
                isi_resource rl
            where
                    r.res_id = rl.parent_res_id
                and exists (
                    select
                        l.lgr_platz
                    from
                        lvs_lgr l
                    where
                            l.lgr_platz = rl.res_name
                        and l.lgr_verwendung = 'WA'
                )
        ) res_name_list,
        (
            select
                count(t.transp_id)
            from
                isi_transport t
            where
                    t.status != 'G'
                and ( ';'
                      || (
                    select
                        stradd_distinct(rl.res_name)
                    from
                        isi_resource rl
                    where
                        ( r.res_id = rl.parent_res_id
                          and exists (
                            select
                                l.lgr_platz
                            from
                                lvs_lgr l
                            where
                                    l.lgr_platz = rl.res_name
                                and l.lgr_verwendung = 'WA'
                        ) )
                        or ( r.res_id = rl.res_id
                             and exists (
                            select
                                l.lgr_platz
                            from
                                lvs_lgr l
                            where
                                    l.lgr_platz = rl.res_name
                                and l.lgr_verwendung = 'WA'
                        ) )
                ) || ';' ) like '%;'
                                || t.lgr_platz_ziel
                                || ';%'
        ) anz_transporte,
        rp.max_transporte,
        rp.max_belegung
    from
        isi_resource      r,
        isi_res_plan_data rp
    where
        r.res_id = rp.res_id;


-- sqlcl_snapshot {"hash":"441cc49f216f573b4581f15fb1fe3f50f0771565","type":"VIEW","name":"LVS_TRANPORT_ZIEL_PRUEFEN","schemaName":"DIRKSPZM32","sxml":""}