
  CREATE INDEX "DIRKSPZM32"."IX_BDE_FA_LTE_LEITZ_AG" ON "DIRKSPZM32"."BDE_FA_AUFTRAG_LTE_POOL" ("LEITZAHL", "LTE_ID", "LTE_VERWENDET") 
  ;


-- sqlcl_snapshot {"hash":"e30a8f4992fed193d6780d94b460557222b5d732","type":"INDEX","name":"IX_BDE_FA_LTE_LEITZ_AG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_LTE_LEITZ_AG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_LTE_POOL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_VERWENDET</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}