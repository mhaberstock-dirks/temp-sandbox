
  CREATE INDEX "DIRKSPZM32"."IX_BDE_FA_AUFTRAG_RES_LISTE" ON "DIRKSPZM32"."BDE_FA_AUFTRAG_RES_LISTE" ("LEITZAHL", "FIRMA_NR", "SID") 
  ;


-- sqlcl_snapshot {"hash":"ea43f6f63f60014c51f8b7c739210bc91c8a3fe0","type":"INDEX","name":"IX_BDE_FA_AUFTRAG_RES_LISTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AUFTRAG_RES_LISTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_RES_LISTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}