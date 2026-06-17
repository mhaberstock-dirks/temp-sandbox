
  CREATE INDEX "DIRKSPZM32"."IX_REP_GRUPPE" ON "DIRKSPZM32"."REP_ABFRAGEN" ("REP_GRUPPE", "REP_ID") 
  ;


-- sqlcl_snapshot {"hash":"446a72561788cec1c04f17d818b6da024009ee71","type":"INDEX","name":"IX_REP_GRUPPE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_REP_GRUPPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>REP_ABFRAGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REP_GRUPPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}