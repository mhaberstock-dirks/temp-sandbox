create index dirkspzm32.ix_lvs_check_log_ix1 on
    dirkspzm32.lvs_check_log (
        login_id,
        check_ts,
        lvs_check_log_id
    );


-- sqlcl_snapshot {"hash":"9cfe2f4bedc9acd4c8962fcd3ac229ae994dd143","type":"INDEX","name":"IX_LVS_CHECK_LOG_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_CHECK_LOG_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_CHECK_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOGIN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_TS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LVS_CHECK_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}