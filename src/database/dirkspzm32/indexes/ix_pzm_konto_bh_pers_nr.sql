
  CREATE INDEX "IX_PZM_KONTO_BH_PERS_NR" ON "PZM_KONTEN_BH" ("PERS_NR", "KONTEN_BH_ID") 
  ;


-- sqlcl_snapshot {"hash":"64e8326fcdc4dc4a81d665547052eca5449a7a91","type":"INDEX","name":"IX_PZM_KONTO_BH_PERS_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PZM_KONTO_BH_PERS_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_KONTEN_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KONTEN_BH_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}