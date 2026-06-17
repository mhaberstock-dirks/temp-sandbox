
  CREATE INDEX "DIRKSPZM32"."IX_LVS_CHECK_LOG_IX3" ON "DIRKSPZM32"."LVS_CHECK_LOG" ("CHECK_TYP", "CHECK_TS", "LVS_CHECK_LOG_ID") 
  ;


-- sqlcl_snapshot {"hash":"4f960a72b823d4b69cbce8fabaec40acbcd9bda9","type":"INDEX","name":"IX_LVS_CHECK_LOG_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_CHECK_LOG_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_CHECK_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_TS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LVS_CHECK_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}