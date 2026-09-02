
  CREATE INDEX "IX_LHM_KOMM_Q_LTE_ID" ON "LVS_LHM" ("KOMM_QUELL_LTE_ID", "LHM_ID") 
  ;


-- sqlcl_snapshot {"hash":"4ad9f1e684e66f443a13735b6df6261b7dbc6f37","type":"INDEX","name":"IX_LHM_KOMM_Q_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LHM_KOMM_Q_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LHM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_QUELL_LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}