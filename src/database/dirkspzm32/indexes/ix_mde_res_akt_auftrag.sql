
  CREATE INDEX "IX_MDE_RES_AKT_AUFTRAG" ON "MDE_RES_AKT" ("AUFTRAG", "RES_NAME") 
  ;


-- sqlcl_snapshot {"hash":"f582a3a5b9c3c323dc2eae90d9394c8bff8c0041","type":"INDEX","name":"IX_MDE_RES_AKT_AUFTRAG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MDE_RES_AKT_AUFTRAG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MDE_RES_AKT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUFTRAG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}