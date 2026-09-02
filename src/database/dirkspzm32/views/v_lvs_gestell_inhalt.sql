
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_LVS_GESTELL_INHALT" ("LGR_PLATZ", "VORGANG_ID", "LI_NR", "LIEFER_DATUM", "ANZ") AS 
  select lam.lgr_platz,
       iop.vorgang_id,
       iop.li_nr,
       iop.liefer_datum,
       count(*) anz
  from lvs_lam lam
inner join isi_order_pos iop on iop.auf_id = lam.order_pos_auf_id
where 1=1
and lam.lgr_platz like'%700%'
group by lam.lgr_platz, iop.vorgang_id, iop.li_nr, iop.liefer_datum
order by iop.li_nr
;


-- sqlcl_snapshot {"hash":"1ea8c2847ece480e3f1269f6c72f7b815e9af81b","type":"VIEW","name":"V_LVS_GESTELL_INHALT","schemaName":"DIRKSPZM32","sxml":""}