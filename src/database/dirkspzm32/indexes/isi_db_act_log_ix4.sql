
  CREATE INDEX "DIRKSPZM32"."ISI_DB_ACT_LOG_IX4" ON "DIRKSPZM32"."ISI_DB_ACT_LOG" ("ACT_COMMAND", "ACT_TABLE", "LOG_DATE", "DB_ACT_LOG_ID") 
  ;


-- sqlcl_snapshot {"hash":"1c813c3df5950459be0899e33e227bd8a1802ae0","type":"INDEX","name":"ISI_DB_ACT_LOG_IX4","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>ISI_DB_ACT_LOG_IX4</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_DB_ACT_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ACT_COMMAND</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACT_TABLE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DB_ACT_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}