create index dirkspzm32.idx_pzm_log_pers_nr on
    dirkspzm32.pzm_log (
        pers_nr,
        log_timestamp
    );


-- sqlcl_snapshot {"hash":"43223906c2ecb9c64a057079c6789392c13426cb","type":"INDEX","name":"IDX_PZM_LOG_PERS_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IDX_PZM_LOG_PERS_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_TIMESTAMP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}