
  CREATE INDEX "DIRKSPZM32"."IX_LAM_BH_BUS_LEITZ_LAM" ON "DIRKSPZM32"."LVS_LAM_BH" ("BUS", "LEITZAHL", "LAM_ID") 
  ;


-- sqlcl_snapshot {"hash":"384f838a9ee3fbe94d4e27691349df4d89b7f358","type":"INDEX","name":"IX_LAM_BH_BUS_LEITZ_LAM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_BUS_LEITZ_LAM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>BUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}