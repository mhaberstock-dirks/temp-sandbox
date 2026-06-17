
  CREATE INDEX "DIRKSPZM32"."IX_MDE_RES_AKT_FA" ON "DIRKSPZM32"."MDE_RES_AKT" ("LEITZAHL", "FA_AG", "FA_UPOS", "RES_NAME") 
  ;


-- sqlcl_snapshot {"hash":"69c1d12867ac4ef583132a1e4511e5f76db8211a","type":"INDEX","name":"IX_MDE_RES_AKT_FA","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MDE_RES_AKT_FA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MDE_RES_AKT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}