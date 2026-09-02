
  CREATE UNIQUE INDEX "IX_LVS_LHM_HIST_TE" ON "LVS_LHM_HIST" ("LTE_ID", "LHM_ID") 
  ;


-- sqlcl_snapshot {"hash":"a2abf8bcd1a51e99558fd76ef2a70f9565443afd","type":"INDEX","name":"IX_LVS_LHM_HIST_TE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LHM_HIST_TE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LHM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}