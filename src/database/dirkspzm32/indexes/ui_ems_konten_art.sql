
  CREATE UNIQUE INDEX "UI_EMS_KONTEN_ART" ON "EMS_KONTEN_ART" ("EMS_KONTO_NR", "EMS_ART_NAME") 
  ;


-- sqlcl_snapshot {"hash":"d4a2c8bf8f619cb5a5d1c1383a7ba1bf1b93df73","type":"INDEX","name":"UI_EMS_KONTEN_ART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UI_EMS_KONTEN_ART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>EMS_KONTEN_ART</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EMS_KONTO_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EMS_ART_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}