
  CREATE INDEX "DIRKSPZM32"."DB_TRACE_LOG_IX2" ON "DIRKSPZM32"."DB_TRACE" ("ISIUSR", "LOG_DATE", "DB_ACT_LOG_ID") 
  ;


-- sqlcl_snapshot {"hash":"fa4301634db00e8d9d9de0582e6259cb1844e793","type":"INDEX","name":"DB_TRACE_LOG_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>DB_TRACE_LOG_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DB_TRACE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ISIUSR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DB_ACT_LOG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}