create index dirkspzm32.db_trace_log_ix3 on
    dirkspzm32.db_trace (
        act_table,
        log_date,
        db_act_log_id
    );


-- sqlcl_snapshot {"hash":"aed6ad9d1c3a1755c59f05524f5994dd96ee987d","type":"INDEX","name":"DB_TRACE_LOG_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>DB_TRACE_LOG_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DB_TRACE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ACT_TABLE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DB_ACT_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}