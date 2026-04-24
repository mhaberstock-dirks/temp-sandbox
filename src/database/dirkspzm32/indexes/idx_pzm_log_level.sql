create index dirkspzm32.idx_pzm_log_level on
    dirkspzm32.pzm_log (
        log_level,
        log_timestamp
    );


-- sqlcl_snapshot {"hash":"ea1ec8f7d6eb95183b7f78f0a3fecd9663c7e1f8","type":"INDEX","name":"IDX_PZM_LOG_LEVEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IDX_PZM_LOG_LEVEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOG_LEVEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_TIMESTAMP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}