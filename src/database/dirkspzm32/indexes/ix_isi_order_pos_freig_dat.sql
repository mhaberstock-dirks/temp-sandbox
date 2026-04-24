create index dirkspzm32.ix_isi_order_pos_freig_dat on
    dirkspzm32.isi_order_pos (
        freigabe_datum,
        auf_id
    );


-- sqlcl_snapshot {"hash":"53ffc9c50f0cc14620bbc4beb2720ce232a90863","type":"INDEX","name":"IX_ISI_ORDER_POS_FREIG_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_FREIG_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FREIGABE_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}