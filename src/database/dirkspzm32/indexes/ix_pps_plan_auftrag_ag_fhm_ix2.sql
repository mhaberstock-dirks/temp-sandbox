
  CREATE INDEX "DIRKSPZM32"."IX_PPS_PLAN_AUFTRAG_AG_FHM_IX2" ON "DIRKSPZM32"."PPS_PLAN_AUFTRAG_AG_FHM" ("PLAN_AUF_AG_ID", "FIRMA_NR", "SID") 
  ;


-- sqlcl_snapshot {"hash":"5102081691c5dcc22a8c67dc1bfe00528923ca18","type":"INDEX","name":"IX_PPS_PLAN_AUFTRAG_AG_FHM_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_PLAN_AUFTRAG_AG_FHM_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_PLAN_AUFTRAG_AG_FHM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_AUF_AG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}