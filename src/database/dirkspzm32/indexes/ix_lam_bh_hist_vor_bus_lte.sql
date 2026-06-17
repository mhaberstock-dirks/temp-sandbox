
  CREATE INDEX "DIRKSPZM32"."IX_LAM_BH_HIST_VOR_BUS_LTE" ON "DIRKSPZM32"."LVS_LAM_BH_HIST" ("VORG_ID", "BUS", "LTE_ID") 
  ;


-- sqlcl_snapshot {"hash":"cc6b1cc2c48a8776998c469250da639367fb49c6","type":"INDEX","name":"IX_LAM_BH_HIST_VOR_BUS_LTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_VOR_BUS_LTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}