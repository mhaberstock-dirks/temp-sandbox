create index dirkspzm32.ix_isi_order_pos_li_nr_pos on
    dirkspzm32.isi_order_pos (
        li_nr,
        li_pos_nr,
        vorgang_typ,
        auf_id
    );


-- sqlcl_snapshot {"hash":"bb8f054c02c5e6a78ed99a23da51d185eea957ed","type":"INDEX","name":"IX_ISI_ORDER_POS_LI_NR_POS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_LI_NR_POS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LI_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LI_POS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}