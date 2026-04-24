create index dirkspzm32.idx_pzm_log_category on
    dirkspzm32.pzm_log (
        log_category,
        log_timestamp
    );


-- sqlcl_snapshot {"hash":"6b905932837c4e7f44285f5f122633e333a4f561","type":"INDEX","name":"IDX_PZM_LOG_CATEGORY","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IDX_PZM_LOG_CATEGORY</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOG_CATEGORY</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_TIMESTAMP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}