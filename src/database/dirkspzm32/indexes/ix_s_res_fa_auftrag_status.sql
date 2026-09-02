
  CREATE INDEX "IX_S_RES_FA_AUFTRAG_STATUS" ON "S_RCV_FA_AUF" ("AG_STATUS", "AUF_ID") 
  ;


-- sqlcl_snapshot {"hash":"52cc6650b3486a33b2b99f047253b9953f1d0eb4","type":"INDEX","name":"IX_S_RES_FA_AUFTRAG_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RES_FA_AUFTRAG_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_FA_AUF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AG_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}