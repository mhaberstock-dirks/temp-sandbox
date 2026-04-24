create index dirkspzm32.ix_isi_order_reord_h_ix2 on
    dirkspzm32.isi_order_reord_h (
        order_action,
        reord_id
    );


-- sqlcl_snapshot {"hash":"80e4c3119022c9c69df7917c70b5be9af9b48c3b","type":"INDEX","name":"IX_ISI_ORDER_REORD_H_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_REORD_H_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_REORD_H</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_ACTION</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REORD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}