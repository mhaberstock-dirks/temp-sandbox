create or replace force editionable view dirkspzm32.lvs_trans_und_ziel_chk2 (
    li_nr,
    leitzahl,
    res_name_list,
    lgr_platz,
    lgr_platz_gruppe,
    anz_transporte_frei,
    anz_lam_order_res_trans_frei,
    anz_lam_order_res_trans_neu,
    anz_lam_order_res_trans_st_t,
    lgr_akt_te,
    max_transporte
) as
    select
        pos.li_nr,
        fa.leitzahl,
        t.res_name_list,
        t.lgr_platz,
        t.lgr_platz_gruppe,
        t.anz_transporte_frei,
        t.anz_lam_order_res_trans_frei,
        t.anz_lam_order_res_trans_neu,
        t.anz_lam_order_res_trans_st_t,
        t.lgr_akt_te,
        t.max_transporte
    from
        lvs_trans_und_ziel_mit_res_chk t
        left join lvs_lte                        lte on t.lgr_platz = lte.lgr_platz
                                 or t.lgr_platz = lte.ziel_lgr_platz
        left join lvs_lam                        lam on lam.lte_id = lte.lte_id
        left join bde_fa_auftrag                 fa on fa.auf_id = lam.order_pos_auf_id
        left join isi_order_pos                  pos on pos.auf_id = lam.order_pos_auf_id
    group by
        pos.li_nr,
        fa.leitzahl,
        t.res_name_list,
        t.lgr_platz,
        t.lgr_platz_gruppe,
        t.anz_transporte_frei,
        t.anz_lam_order_res_trans_frei,
        t.anz_lam_order_res_trans_neu,
        t.anz_lam_order_res_trans_st_t,
        t.lgr_akt_te,
        t.max_transporte
    order by
        t.lgr_platz_gruppe,
        t.lgr_platz;


-- sqlcl_snapshot {"hash":"c7d535e8a36f134851ba681a711ccf47afce2824","type":"VIEW","name":"LVS_TRANS_UND_ZIEL_CHK2","schemaName":"DIRKSPZM32","sxml":""}