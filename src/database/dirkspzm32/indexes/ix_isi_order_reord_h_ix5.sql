create index dirkspzm32.ix_isi_order_reord_h_ix5 on
    dirkspzm32.isi_order_reord_h (
        created_date,
        reord_id
    );


-- sqlcl_snapshot {"hash":"21477c530370d85daca2e4dd3eb05d5ae07657e0","type":"INDEX","name":"IX_ISI_ORDER_REORD_H_IX5","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_REORD_H_IX5</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_REORD_H</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REORD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}