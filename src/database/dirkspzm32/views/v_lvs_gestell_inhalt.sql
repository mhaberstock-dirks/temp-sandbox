create or replace force editionable view dirkspzm32.v_lvs_gestell_inhalt (
    lgr_platz,
    vorgang_id,
    li_nr,
    liefer_datum,
    anz
) as
    select
        lam.lgr_platz,
        iop.vorgang_id,
        iop.li_nr,
        iop.liefer_datum,
        count(*) anz
    from
             lvs_lam lam
        inner join isi_order_pos iop on iop.auf_id = lam.order_pos_auf_id
    where
            1 = 1
        and lam.lgr_platz like '%700%'
    group by
        lam.lgr_platz,
        iop.vorgang_id,
        iop.li_nr,
        iop.liefer_datum
    order by
        iop.li_nr;


-- sqlcl_snapshot {"hash":"e6674a7de5e29fadb6cf7085770721731658ad4a","type":"VIEW","name":"V_LVS_GESTELL_INHALT","schemaName":"DIRKSPZM32","sxml":""}