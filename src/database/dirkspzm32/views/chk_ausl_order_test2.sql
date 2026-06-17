
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."CHK_AUSL_ORDER_TEST2" ("OK_STATUS", "AUF_ID", "ARTIKEL", "MENGE") AS 
  select l.OK_STATUS,
       l.auf_id,
       l.artikel,
       sum(l.menge) menge
  from (select case when t.Reserviert = 'Frei' and
                         t.check_fa like '%OK%' and
                         t.q_lgr_ort_semikolon like '%OK%' and
                         t.order_pos_auto_depal like '%OK%' and
                         t.order_pos_ware_disponiert like '%OK%' and
                         t.m_inv like '%OK%' and
                         t.Labor_ST like '%OK%' and
                         t.lam_sel1_10 like '%OK%' and
                         t.charge like '%OK%' and
                         t.serie like '%OK%' and
                         t.mhd like '%OK%' and
                         t.min_mhd like '%OK%' and
                         t.anbruch like '%OK%' and
                         t.chk_reserv like '%OK%' and
                         t.KONSI like '%OK%' and
                         t.p_datum like '%OK%' and
                         t.LGR_GESPERRT like '%OK%' and
                         t.l_inv like '%OK%' and
                         t.l_orte like '%OK%' and
                         t.z_idx like '%OK%' and
                         (t.Farzeug_OK like '%OK%' or t.Farzeug_OK like '%T%')
                    then
                      'OK'
                    else
                      'ERR'
                    end OK_STATUS,
               t.auf_id,
               t.artikel,
               t.lte_id,
               t.menge
          from chk_ausl_order_test t) l
 group by l.OK_STATUS,
          l.auf_id,
          l.artikel
 order by l.artikel
;


-- sqlcl_snapshot {"hash":"ed0910b18560bf2312ebe2820f0e9e70f39fb11f","type":"VIEW","name":"CHK_AUSL_ORDER_TEST2","schemaName":"DIRKSPZM32","sxml":""}