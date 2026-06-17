
  CREATE INDEX "DIRKSPZM32"."IX_KOMM_TNK_ID" ON "DIRKSPZM32"."ISI_KOMM_ORDER" ("TRANSP_ID_NACH_KOMM") 
  ;


-- sqlcl_snapshot {"hash":"8180b932bc75d8bb42d9545c34002b30f684a354","type":"INDEX","name":"IX_KOMM_TNK_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_TNK_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TRANSP_ID_NACH_KOMM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}