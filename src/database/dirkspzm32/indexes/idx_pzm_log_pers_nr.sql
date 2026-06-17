
  CREATE INDEX "DIRKSPZM32"."IDX_PZM_LOG_PERS_NR" ON "DIRKSPZM32"."PZM_LOG" ("PERS_NR", "LOG_TIMESTAMP") 
  ;


-- sqlcl_snapshot {"hash":"a1d23865abe0596816783becd62c8109b02947e1","type":"INDEX","name":"IDX_PZM_LOG_PERS_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IDX_PZM_LOG_PERS_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_TIMESTAMP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}