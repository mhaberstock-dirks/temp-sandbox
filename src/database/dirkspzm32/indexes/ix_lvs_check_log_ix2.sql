
  CREATE INDEX "DIRKSPZM32"."IX_LVS_CHECK_LOG_IX2" ON "DIRKSPZM32"."LVS_CHECK_LOG" ("ARBEITSPLATZ_ID", "CHECK_TS", "LVS_CHECK_LOG_ID") 
  ;


-- sqlcl_snapshot {"hash":"007a8e037682be02461375561b1d60bb8169848d","type":"INDEX","name":"IX_LVS_CHECK_LOG_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_CHECK_LOG_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_CHECK_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARBEITSPLATZ_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_TS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LVS_CHECK_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}