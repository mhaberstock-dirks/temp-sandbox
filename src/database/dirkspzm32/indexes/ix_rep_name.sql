
  CREATE INDEX "DIRKSPZM32"."IX_REP_NAME" ON "DIRKSPZM32"."REP_ABFRAGEN" ("REP_NAME", "REP_ID") 
  ;


-- sqlcl_snapshot {"hash":"41a19ba3cc2f3cf197bdc56e0cf9a1491638d8e3","type":"INDEX","name":"IX_REP_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_REP_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>REP_ABFRAGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REP_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}