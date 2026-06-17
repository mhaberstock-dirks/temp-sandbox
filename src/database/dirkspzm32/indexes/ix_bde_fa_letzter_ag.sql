
  CREATE INDEX "DIRKSPZM32"."IX_BDE_FA_LETZTER_AG" ON "DIRKSPZM32"."BDE_FA_AUFTRAG" ("LEITZAHL", "KENZ_LETZT_AG", "AG_ID") 
  ;


-- sqlcl_snapshot {"hash":"8cf1126a1bb2d3cb4785495f84c4cdf4f8aa4710","type":"INDEX","name":"IX_BDE_FA_LETZTER_AG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_LETZTER_AG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KENZ_LETZT_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}