
  CREATE UNIQUE INDEX "PK_ISI_RES_FHM_LIST" ON "ISI_RES_FHM_LIST" ("FHM", "RES_ID", "DATUM_VON") 
  ;


-- sqlcl_snapshot {"hash":"2f2d5bbc552dc3a79a2896bfe76cb6b568dbf5fd","type":"INDEX","name":"PK_ISI_RES_FHM_LIST","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PK_ISI_RES_FHM_LIST</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_FHM_LIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FHM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM_VON</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}