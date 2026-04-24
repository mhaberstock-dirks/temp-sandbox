create index dirkspzm32.ix_komm_order_ts on
    dirkspzm32.isi_komm_order (
        ts
    );


-- sqlcl_snapshot {"hash":"e26fc2bb4532091f39b005eb2c5853c62d77c9ae","type":"INDEX","name":"IX_KOMM_ORDER_TS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_ORDER_TS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}