create or replace force editionable view dirkspzm32.lvs_trans_ziel_mit_res_chk_3 (
    res_name_list,
    lgr_platz,
    lgr_platz_gruppe,
    anz_lam_order_res_trans_frei,
    lgr_akt_te,
    max_transporte
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
        )      res_name_list,
        l.lgr_platz,
        l.lgr_platz_gruppe,
        (
            select
                count(lam.lam_id)
            from
                isi_transport t,
                lvs_lam       lam
            where
                    t.lte_id = lam.lte_id
                and lam.order_pos_auf_id is not null
                and t.status != 'G'
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
        )      anz_lam_order_res_trans_frei,
        nvl((
            select
                sum(lx.res_menge)
            from
                lvs_lam lx
            where
                lx.lgr_platz = l.lgr_platz
        ),
            0) lgr_akt_te,
       --nvl(l.lgr_akt_te, 0) lgr_akt_te,
        case
            when isi_allg.get_firma_cfg_param(r.sid, r.firma_nr, 'CFG', null, 'Z_HAG_AP07_PRODUKTION_AN',
                                                  'BDE', 'CFG', 'F', 'BOOLEAN') = 'T'
                 and l.lgr_platz_gruppe like 'SEQ_PROD_%'
                 and ( (
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
            ) = 0
                       or (
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
            ) + nvl((
                select
                    sum(lx.res_menge)
                from
                    lvs_lam lx
                where
                    lx.lgr_platz = l.lgr_platz
            ),
                    0) > rp.max_transporte ) then
                rp.max_transporte + 1
            else
                rp.max_transporte
        end    max_transporte
    from
        isi_resource      r,
        isi_res_plan_data rp,
        lvs_lgr           l
    where
            r.res_id = rp.res_id
        and r.lager_fertig = l.lgr_platz (+)
    order by
        l.lgr_platz_gruppe,
        r.res_name;


-- sqlcl_snapshot {"hash":"03e8b6b8760062f13fac53f9fc4740c84e576b50","type":"VIEW","name":"LVS_TRANS_ZIEL_MIT_RES_CHK_3","schemaName":"DIRKSPZM32","sxml":""}