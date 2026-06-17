
  CREATE UNIQUE INDEX "DIRKSPZM32"."IX_PERS_NR_NAME_KURZ" ON "DIRKSPZM32"."PZM_KONTEN" ("PERS_NR", "NAME_KURZ") 
  ;


-- sqlcl_snapshot {"hash":"02123be01642aa60959c19922268e99af1103c04","type":"INDEX","name":"IX_PERS_NR_NAME_KURZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PERS_NR_NAME_KURZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_KONTEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NAME_KURZ</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}