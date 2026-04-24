create index dirkspzm32.ix_isi_order_reord_h_ix1 on
    dirkspzm32.isi_order_reord_h (
        scan_string,
        reord_id
    );


-- sqlcl_snapshot {"hash":"9981f180f0b16c9b82110b07cef0657296ceb3b7","type":"INDEX","name":"IX_ISI_ORDER_REORD_H_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_REORD_H_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_REORD_H</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SCAN_STRING</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REORD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}