
  CREATE INDEX "DIRKSPZM32"."IX_LAM_BH_HIST_BUS_LEITZ_LAM" ON "DIRKSPZM32"."LVS_LAM_BH_HIST" ("BUS", "LEITZAHL", "LAM_ID") 
  ;


-- sqlcl_snapshot {"hash":"03d89f9466cbe050c02c8e160c9cf3efd51a14bc","type":"INDEX","name":"IX_LAM_BH_HIST_BUS_LEITZ_LAM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_BUS_LEITZ_LAM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>BUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}