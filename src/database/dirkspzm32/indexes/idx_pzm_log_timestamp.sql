create index dirkspzm32.idx_pzm_log_timestamp on
    dirkspzm32.pzm_log (
        log_timestamp
    );


-- sqlcl_snapshot {"hash":"a3ff3bcc243a45dd1a19d8cc0f094071a7134e2d","type":"INDEX","name":"IDX_PZM_LOG_TIMESTAMP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IDX_PZM_LOG_TIMESTAMP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOG_TIMESTAMP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}