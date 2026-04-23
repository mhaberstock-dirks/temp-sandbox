create index dirkspzm32.ix_komm_order_bearb_dat on
    dirkspzm32.isi_komm_order (
        bearb_start_datum
    );


-- sqlcl_snapshot {"hash":"8cc2305b09d0653f8833b9e3bee46b40c03d428d","type":"INDEX","name":"IX_KOMM_ORDER_BEARB_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_ORDER_BEARB_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>BEARB_START_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}