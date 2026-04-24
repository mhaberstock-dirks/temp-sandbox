create index dirkspzm32.ix_send_bew_lte_nr_status on
    dirkspzm32.s_send_bew (
        lte_nr,
        status
    );


-- sqlcl_snapshot {"hash":"a999fead7b4187664584b6956e00675d8d27f68e","type":"INDEX","name":"IX_SEND_BEW_LTE_NR_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_SEND_BEW_LTE_NR_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}