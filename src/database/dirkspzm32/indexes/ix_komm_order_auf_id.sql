create index dirkspzm32.ix_komm_order_auf_id on
    dirkspzm32.isi_komm_order (
        auf_id
    );


-- sqlcl_snapshot {"hash":"d3c8c7364ed3d7d6c7402d55531b973fe06490d8","type":"INDEX","name":"IX_KOMM_ORDER_AUF_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_ORDER_AUF_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}