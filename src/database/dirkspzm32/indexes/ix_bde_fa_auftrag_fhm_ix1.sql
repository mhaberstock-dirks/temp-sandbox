
  CREATE INDEX "DIRKSPZM32"."IX_BDE_FA_AUFTRAG_FHM_IX1" ON "DIRKSPZM32"."BDE_FA_AUFTRAG_FHM" ("ABNR", "FIRMA_NR", "SID") 
  ;


-- sqlcl_snapshot {"hash":"0e6724af65a41bc471c2dfb2f6530f2701b35dc8","type":"INDEX","name":"IX_BDE_FA_AUFTRAG_FHM_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AUFTRAG_FHM_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_FHM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ABNR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}