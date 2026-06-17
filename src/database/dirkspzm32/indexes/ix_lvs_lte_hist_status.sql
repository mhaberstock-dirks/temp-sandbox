
  CREATE INDEX "DIRKSPZM32"."IX_LVS_LTE_HIST_STATUS" ON "DIRKSPZM32"."LVS_LTE_HIST" ("LTE_STATUS", "LTE_ID") 
  ;


-- sqlcl_snapshot {"hash":"25a64f041b52d70715229a8ab657ea6995496fc8","type":"INDEX","name":"IX_LVS_LTE_HIST_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}