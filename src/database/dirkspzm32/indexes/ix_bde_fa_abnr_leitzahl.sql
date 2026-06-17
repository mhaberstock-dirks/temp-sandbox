
  CREATE INDEX "DIRKSPZM32"."IX_BDE_FA_ABNR_LEITZAHL" ON "DIRKSPZM32"."BDE_FA_AUFTRAG" ("ABNR", "LEITZAHL") 
  ;


-- sqlcl_snapshot {"hash":"5e2f10cdb79b1070c9f3510999836c9fcf032787","type":"INDEX","name":"IX_BDE_FA_ABNR_LEITZAHL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_ABNR_LEITZAHL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ABNR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}