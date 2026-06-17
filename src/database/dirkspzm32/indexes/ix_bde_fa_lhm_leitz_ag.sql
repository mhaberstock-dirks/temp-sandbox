
  CREATE INDEX "DIRKSPZM32"."IX_BDE_FA_LHM_LEITZ_AG" ON "DIRKSPZM32"."BDE_FA_AUFTRAG_LHM_POOL" ("LEITZAHL", "FA_AG", "FA_UPOS") 
  ;


-- sqlcl_snapshot {"hash":"b638326186a4816946d0d997eeffc50ae1d543e8","type":"INDEX","name":"IX_BDE_FA_LHM_LEITZ_AG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_LHM_LEITZ_AG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_LHM_POOL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}