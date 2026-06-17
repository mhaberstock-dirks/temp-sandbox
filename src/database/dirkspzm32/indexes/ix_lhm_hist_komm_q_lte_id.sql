
  CREATE INDEX "DIRKSPZM32"."IX_LHM_HIST_KOMM_Q_LTE_ID" ON "DIRKSPZM32"."LVS_LHM_HIST" ("KOMM_QUELL_LTE_ID", "LHM_ID") 
  ;


-- sqlcl_snapshot {"hash":"ab5bd99153434fb06d62a7a3354d5b56e886b7ac","type":"INDEX","name":"IX_LHM_HIST_KOMM_Q_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LHM_HIST_KOMM_Q_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LHM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_QUELL_LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}