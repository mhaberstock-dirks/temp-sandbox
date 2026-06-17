
  CREATE UNIQUE INDEX "DIRKSPZM32"."IX_BDE_FA_AUFTRAG_LTE_P_VERW" ON "DIRKSPZM32"."BDE_FA_AUFTRAG_LTE_POOL" ("LTE_VERWENDET", "LTE_ID") 
  ;


-- sqlcl_snapshot {"hash":"6f57424e556cf8f0738d27c56e60ea6707bbcfbf","type":"INDEX","name":"IX_BDE_FA_AUFTRAG_LTE_P_VERW","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AUFTRAG_LTE_P_VERW</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_LTE_POOL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_VERWENDET</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}