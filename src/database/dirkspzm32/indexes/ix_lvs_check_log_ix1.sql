
  CREATE INDEX "DIRKSPZM32"."IX_LVS_CHECK_LOG_IX1" ON "DIRKSPZM32"."LVS_CHECK_LOG" ("LOGIN_ID", "CHECK_TS", "LVS_CHECK_LOG_ID") 
  ;


-- sqlcl_snapshot {"hash":"ab03d99dcddf821f8acbd4959cb52f82c940c7b9","type":"INDEX","name":"IX_LVS_CHECK_LOG_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_CHECK_LOG_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_CHECK_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOGIN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHECK_TS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LVS_CHECK_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}