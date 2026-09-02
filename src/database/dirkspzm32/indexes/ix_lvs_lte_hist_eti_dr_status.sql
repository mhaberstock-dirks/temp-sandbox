
  CREATE INDEX "IX_LVS_LTE_HIST_ETI_DR_STATUS" ON "LVS_LTE_HIST" ("LTE_ETI_DRUCK_STATUS", "LTE_ID") 
  ;


-- sqlcl_snapshot {"hash":"77c1544812317e414ccb7ce3df917267c4f0ab9f","type":"INDEX","name":"IX_LVS_LTE_HIST_ETI_DR_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_ETI_DR_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ETI_DRUCK_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}