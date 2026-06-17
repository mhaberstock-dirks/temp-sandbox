
  CREATE INDEX "DIRKSPZM32"."IX_S_RES_FA_AUFTRAG_STATUS" ON "DIRKSPZM32"."S_RCV_FA_AUF" ("AG_STATUS", "AUF_ID") 
  ;


-- sqlcl_snapshot {"hash":"be247e04d13e2029acf8f18d15f4a0e95c3be739","type":"INDEX","name":"IX_S_RES_FA_AUFTRAG_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RES_FA_AUFTRAG_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_FA_AUF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AG_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}