
  CREATE INDEX "DIRKSPZM32"."IX_PPS_PLAN_AUFTRAG_IX2" ON "DIRKSPZM32"."PPS_PLAN_AUFTRAG" ("STATUS", "PLAN_AUF_ID") 
  ;


-- sqlcl_snapshot {"hash":"787299a9bd532793f47c8bc08ac85a24db381f0b","type":"INDEX","name":"IX_PPS_PLAN_AUFTRAG_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_PLAN_AUFTRAG_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_PLAN_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}