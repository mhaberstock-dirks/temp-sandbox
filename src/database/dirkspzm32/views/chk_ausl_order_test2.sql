create or replace force editionable view dirkspzm32.chk_ausl_order_test2 (
    ok_status,
    auf_id,
    artikel,
    menge
) as
    select
        l.ok_status,
        l.auf_id,
        l.artikel,
        sum(l.menge) menge
    from
        (
            select
                case
                    when t.reserviert = 'Frei'
                         and t.check_fa like '%OK%'
                         and t.q_lgr_ort_semikolon like '%OK%'
                         and t.order_pos_auto_depal like '%OK%'
                         and t.order_pos_ware_disponiert like '%OK%'
                         and t.m_inv like '%OK%'
                         and t.labor_st like '%OK%'
                         and t.lam_sel1_10 like '%OK%'
                         and t.charge like '%OK%'
                         and t.serie like '%OK%'
                         and t.mhd like '%OK%'
                         and t.min_mhd like '%OK%'
                         and t.anbruch like '%OK%'
                         and t.chk_reserv like '%OK%'
                         and t.konsi like '%OK%'
                         and t.p_datum like '%OK%'
                         and t.lgr_gesperrt like '%OK%'
                         and t.l_inv like '%OK%'
                         and t.l_orte like '%OK%'
                         and t.z_idx like '%OK%'
                         and ( t.farzeug_ok like '%OK%'
                               or t.farzeug_ok like '%T%' ) then
                        'OK'
                    else
                        'ERR'
                end ok_status,
                t.auf_id,
                t.artikel,
                t.lte_id,
                t.menge
            from
                chk_ausl_order_test t
        ) l
    group by
        l.ok_status,
        l.auf_id,
        l.artikel
    order by
        l.artikel;


-- sqlcl_snapshot {"hash":"a7d15342e1ca270bae7880789c1851d5d8c16f45","type":"VIEW","name":"CHK_AUSL_ORDER_TEST2","schemaName":"DIRKSPZM32","sxml":""}