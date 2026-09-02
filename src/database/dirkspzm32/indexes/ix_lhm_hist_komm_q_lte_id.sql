
  CREATE INDEX "IX_LHM_HIST_KOMM_Q_LTE_ID" ON "LVS_LHM_HIST" ("KOMM_QUELL_LTE_ID", "LHM_ID") 
  ;


-- sqlcl_snapshot {"hash":"cf659744cbf254185a9e4349f86dfcd4583f6a9a","type":"INDEX","name":"IX_LHM_HIST_KOMM_Q_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LHM_HIST_KOMM_Q_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LHM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_QUELL_LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}