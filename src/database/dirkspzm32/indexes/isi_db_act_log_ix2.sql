
  CREATE INDEX "DIRKSPZM32"."ISI_DB_ACT_LOG_IX2" ON "DIRKSPZM32"."ISI_DB_ACT_LOG" ("ISIUSR", "LOG_DATE", "DB_ACT_LOG_ID") 
  ;


-- sqlcl_snapshot {"hash":"5c0a1124c01175cc24d9688161ba96f1ac98e735","type":"INDEX","name":"ISI_DB_ACT_LOG_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_DB_ACT_LOG_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_DB_ACT_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ISIUSR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DB_ACT_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}