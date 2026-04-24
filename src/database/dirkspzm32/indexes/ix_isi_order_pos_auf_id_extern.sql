create index dirkspzm32.ix_isi_order_pos_auf_id_extern on
    dirkspzm32.isi_order_pos (
        auf_id_extern
    );


-- sqlcl_snapshot {"hash":"d10c49f89eab3f8c7380365e1aac4be11487bbcc","type":"INDEX","name":"IX_ISI_ORDER_POS_AUF_ID_EXTERN","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_AUF_ID_EXTERN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID_EXTERN</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}