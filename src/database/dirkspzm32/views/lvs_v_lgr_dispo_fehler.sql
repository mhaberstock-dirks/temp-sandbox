create or replace force editionable view dirkspzm32.lvs_v_lgr_dispo_fehler (
    id,
    fehler,
    res_string,
    transp_id,
    lgr_platz,
    lgr_platz_gruppe,
    lgr_max_te,
    lgr_akt_te,
    lgr_akt_kg,
    lgr_dispo_einl_te,
    lgr_dispo_einl_kg,
    lgr_einl_te_verfueg,
    lgr_einl_te_verfueg_gruppe,
    lgr_dispo_ausl_te,
    lgr_dispo_ausl_kg
) as
    (
        select
            1                               id,
            '[1] Storage Dispo In is wrong' fehler,
            lgr.res_string,
            0                               transp_id,
            lgr.lgr_platz,
            lgr.lgr_platz_gruppe,
            lgr.lgr_max_te,
            lgr.lgr_akt_te,
            lgr.lgr_akt_kg,
            lgr.lgr_dispo_einl_te,
            lgr.lgr_dispo_einl_kg,
            lgr.lgr_einl_te_verfueg,
            lgr.lgr_einl_te_verfueg_gruppe,
            lgr.lgr_dispo_ausl_te,
            lgr.lgr_dispo_ausl_kg
        from
            lvs_lgr lgr
        where
                lgr.lgr_dispo_einl_te <> (
                    select
                        count(tr.transp_id)
                    from
                        isi_transport tr
                    where
                        tr.lgr_platz_ziel = lgr.lgr_platz
                )
            and lgr_verwendung in ( 'Lager', 'Puffer' )
    )
    union
    (
        select
            3                                id,
            '[3] Storage Dispo Out is wrong' fehler,
            lgr.res_string,
            0                                transp_id,
            lgr.lgr_platz,
            lgr.lgr_platz_gruppe,
            lgr.lgr_max_te,
            lgr.lgr_akt_te,
            lgr.lgr_akt_kg,
            lgr.lgr_dispo_einl_te,
            lgr.lgr_dispo_einl_kg,
            lgr.lgr_einl_te_verfueg,
            lgr.lgr_einl_te_verfueg_gruppe,
            lgr.lgr_dispo_ausl_te,
            lgr.lgr_dispo_ausl_kg
        from
            lvs_lgr lgr
        where
            lgr_verwendung in ( 'Lager', 'Puffer' )
            and lgr.lgr_dispo_ausl_te <> (
                select
                    count(tr.transp_id)
                from
                    isi_transport tr
                where
                        tr.lgr_platz_quelle = lgr.lgr_platz
                    and tr.status in ( 'F', 'B' )
            )
    )
    union
    (
        select
            4                                        id,
            '[4] Storage Actual Amount > Max Amount' fehler,
            lgr.res_string,
            0                                        transp_id,
            lgr.lgr_platz,
            lgr.lgr_platz_gruppe,
            lgr.lgr_max_te,
            lgr.lgr_akt_te,
            lgr.lgr_akt_kg,
            lgr.lgr_dispo_einl_te,
            lgr.lgr_dispo_einl_kg,
            lgr.lgr_einl_te_verfueg,
            lgr.lgr_einl_te_verfueg_gruppe,
            lgr.lgr_dispo_ausl_te,
            lgr.lgr_dispo_ausl_kg
        from
            lvs_lgr lgr
        where
                lgr.lgr_akt_te > lgr.lgr_max_te
            and lgr_verwendung in ( 'Lager', 'Puffer' )
    )
    union
    (
        select
            5                                    id,
            '[5] Storage Actual Amount is wrong' fehler,
            lgr.res_string,
            0                                    transp_id,
            lgr.lgr_platz,
            lgr.lgr_platz_gruppe,
            lgr.lgr_max_te,
            lgr.lgr_akt_te,
            lgr.lgr_akt_kg,
            lgr.lgr_dispo_einl_te,
            lgr.lgr_dispo_einl_kg,
            lgr.lgr_einl_te_verfueg,
            lgr.lgr_einl_te_verfueg_gruppe,
            lgr.lgr_dispo_ausl_te,
            lgr.lgr_dispo_ausl_kg
        from
            lvs_lgr lgr
        where
                lgr.lgr_akt_te <> (
                    select
                        count(*)
                    from
                        lvs_lte lte
                    where
                        lte.lgr_platz = lgr.lgr_platz
                )
            and lgr_verwendung in ( 'Lager', 'Puffer' )
    )
    union
    (
        select
            6                                            id,
            '[6] Storage Actual Amount of free is wrong' fehler,
            lgr.res_string,
            0                                            transp_id,
            lgr.lgr_platz,
            lgr.lgr_platz_gruppe,
            lgr.lgr_max_te,
            lgr.lgr_akt_te,
            lgr.lgr_akt_kg,
            lgr.lgr_dispo_einl_te,
            lgr.lgr_dispo_einl_kg,
            lgr.lgr_einl_te_verfueg,
            lgr.lgr_einl_te_verfueg_gruppe,
            lgr.lgr_dispo_ausl_te,
            lgr.lgr_dispo_ausl_kg
        from
            lvs_lgr lgr
        where
            ( lgr.lgr_einl_te_verfueg_gruppe <> (
                select
                    sum(lgr_g.verfueg) verfueg_g
                from
                    (
                        select
                            lgr_x.lgr_max_te - lgr_x.lgr_akt_te - lgr_x.lgr_dispo_einl_te verfueg
                        from
                            lvs_lgr lgr_x
                        where
                                lgr_x.lgr_platz_gruppe = lgr.lgr_platz_gruppe
                            and ( ( lgr_x.lgr_dim_g = lgr.lgr_dim_g
                                    and lgr_x.lgr_dim_r = lgr.lgr_dim_r
                                    and lgr_x.lgr_dim_p = lgr.lgr_dim_p
                                    and lgr_x.lgr_dim_e = lgr.lgr_dim_e )
                                  or ( lgr_x.lgr_typ != c.r_seg1
                                       and lgr_x.lgr_typ != c.r_seg_duedo1 ) )
                    ) lgr_g
            )
              or lgr.lgr_einl_te_verfueg <> (
                select
                    lgr_x.lgr_max_te - lgr_x.lgr_akt_te - lgr_x.lgr_dispo_einl_te
                from
                    lvs_lgr lgr_x
                where
                    lgr_x.lgr_platz = lgr.lgr_platz
            ) )
            and lgr_verwendung in ( 'Lager', 'Puffer' )
    )
    union
    (
        select
            7                                         id,
            '[7] Storage reservation string is wrong' fehler,
            lgr.res_string,
            0                                         transp_id,
            lgr.lgr_platz,
            lgr.lgr_platz_gruppe,
            lgr.lgr_max_te,
            lgr.lgr_akt_te,
            lgr.lgr_akt_kg,
            lgr.lgr_dispo_einl_te,
            lgr.lgr_dispo_einl_kg,
            lgr.lgr_einl_te_verfueg,
            lgr.lgr_einl_te_verfueg_gruppe,
            lgr.lgr_dispo_ausl_te,
            lgr.lgr_dispo_ausl_kg
        from
            lvs_lgr lgr
        where
            lgr.res_string is not null
            and lgr_verwendung in ( 'Lager', 'Puffer' )
            and (
                select
                    ( sum(lgr_x.lgr_akt_te) + sum(lgr_x.lgr_dispo_einl_te) ) dispos
                from
                    lvs_lgr lgr_x
                where
                    lgr_x.lgr_platz_gruppe = lgr.lgr_platz_gruppe
            ) = 0
    )
    union
    (
        select
            8                                                          id,
            '[8] Transport Error, Transport Unit is removed in System' fehler,
            lgr.res_string,
            tr.transp_id                                               transp_id,
            lgr.lgr_platz,
            lgr.lgr_platz_gruppe,
            lgr.lgr_max_te,
            lgr.lgr_akt_te,
            lgr.lgr_akt_kg,
            lgr.lgr_dispo_einl_te,
            lgr.lgr_dispo_einl_kg,
            lgr.lgr_einl_te_verfueg,
            lgr.lgr_einl_te_verfueg_gruppe,
            lgr.lgr_dispo_ausl_te,
            lgr.lgr_dispo_ausl_kg
        from
            isi_transport tr,
            lvs_lgr       lgr
        where
                1 = 1
            and tr.lgr_platz_ziel = lgr.lgr_platz (+)
            and ( not exists (
                select
                    y.lte_id
                from
                    lvs_lam y
                where
                    y.lte_id = tr.lte_id
            )
                      or not exists (
                select
                    z.lte_id
                from
                    lvs_lte z
                where
                    z.lte_id = tr.lte_id
            ) )
    );


-- sqlcl_snapshot {"hash":"75f783f5946f7d55cad715f24d53fc121721547d","type":"VIEW","name":"LVS_V_LGR_DISPO_FEHLER","schemaName":"DIRKSPZM32","sxml":""}