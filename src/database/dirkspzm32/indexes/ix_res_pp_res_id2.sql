
  CREATE INDEX "DIRKSPZM32"."IX_RES_PP_RES_ID2" ON "DIRKSPZM32"."ISI_RES_PROD_PLATZ" ("PROD_PLATZ_RES_ID", "SID", "FIRMA_NR") 
  ;


-- sqlcl_snapshot {"hash":"ff7fae04327cc7b056506deeab997a183c518fd5","type":"INDEX","name":"IX_RES_PP_RES_ID2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_PP_RES_ID2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_PROD_PLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PROD_PLATZ_RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}