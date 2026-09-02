
  CREATE INDEX "IX_LVS_CHECK_LOG_IX4" ON "LVS_CHECK_LOG" ("CHECK_PASSED", "CHECK_TS", "LVS_CHECK_LOG_ID") 
  ;


-- sqlcl_snapshot {"hash":"a765c937a2f8027cb29dba982c42536a369485cb","type":"INDEX","name":"IX_LVS_CHECK_LOG_IX4","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_CHECK_LOG_IX4</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_CHECK_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_PASSED</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_TS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LVS_CHECK_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}