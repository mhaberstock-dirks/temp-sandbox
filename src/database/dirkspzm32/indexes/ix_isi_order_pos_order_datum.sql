create index dirkspzm32.ix_isi_order_pos_order_datum on
    dirkspzm32.isi_order_pos (
        order_datum,
        auf_id
    );


-- sqlcl_snapshot {"hash":"f7aa6cf5420d7bc3c10d6899a65468d84fc858f7","type":"INDEX","name":"IX_ISI_ORDER_POS_ORDER_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_ORDER_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}