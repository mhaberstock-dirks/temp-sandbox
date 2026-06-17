
  CREATE INDEX "DIRKSPZM32"."IX_LAM_BH_HIST_LEIT_LAM_LTE_A" ON "DIRKSPZM32"."LVS_LAM_BH_HIST" ("LEITZAHL", "LHM_ID", "LTE_ID", "ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"d3d23eae9b471bd63a8faa2083c7e1787ec711c1","type":"INDEX","name":"IX_LAM_BH_HIST_LEIT_LAM_LTE_A","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_LEIT_LAM_LTE_A</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}