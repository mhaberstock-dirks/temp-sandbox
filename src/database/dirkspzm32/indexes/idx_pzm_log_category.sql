
  CREATE INDEX "IDX_PZM_LOG_CATEGORY" ON "PZM_LOG" ("LOG_CATEGORY", "LOG_TIMESTAMP") 
  ;


-- sqlcl_snapshot {"hash":"76d5916f1d6ecfce9c8dc27102b2c0c69112422f","type":"INDEX","name":"IDX_PZM_LOG_CATEGORY","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IDX_PZM_LOG_CATEGORY</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOG_CATEGORY</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_TIMESTAMP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}