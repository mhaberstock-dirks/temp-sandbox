
  CREATE INDEX "DIRKSPZM32"."IX_PPS_PLAN_AUFTRAG_IX1" ON "DIRKSPZM32"."PPS_PLAN_AUFTRAG" ("PLAN_AUF_ID_EXT", "PLAN_AUF_ID", "FIRMA_NR", "SID") 
  ;


-- sqlcl_snapshot {"hash":"f31c96896c73a3d7d57ce4039a17179104fa05f2","type":"INDEX","name":"IX_PPS_PLAN_AUFTRAG_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_PLAN_AUFTRAG_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_PLAN_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_AUF_ID_EXT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_AUF_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}