create index dirkspzm32.ix_komm_order_vorg_id on
    dirkspzm32.isi_komm_order (
        vorgang_id
    );


-- sqlcl_snapshot {"hash":"c22c6dfb3c884495a35a4d5c8d95fba0e8752dda","type":"INDEX","name":"IX_KOMM_ORDER_VORG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_ORDER_VORG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}