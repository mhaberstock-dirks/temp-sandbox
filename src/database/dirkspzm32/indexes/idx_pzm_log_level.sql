
  CREATE INDEX "DIRKSPZM32"."IDX_PZM_LOG_LEVEL" ON "DIRKSPZM32"."PZM_LOG" ("LOG_LEVEL", "LOG_TIMESTAMP") 
  ;


-- sqlcl_snapshot {"hash":"70e4bc789385ec47c684628c99ccc9cc5936a1b7","type":"INDEX","name":"IDX_PZM_LOG_LEVEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IDX_PZM_LOG_LEVEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOG_LEVEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_TIMESTAMP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}