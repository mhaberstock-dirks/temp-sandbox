create index dirkspzm32.ix_lvs_check_log_ix4 on
    dirkspzm32.lvs_check_log (
        check_passed,
        check_ts,
        lvs_check_log_id
    );


-- sqlcl_snapshot {"hash":"1301f8e30b58f14e0054f8f2876ee6ab78e02ede","type":"INDEX","name":"IX_LVS_CHECK_LOG_IX4","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_CHECK_LOG_IX4</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_CHECK_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_PASSED</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_TS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LVS_CHECK_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}