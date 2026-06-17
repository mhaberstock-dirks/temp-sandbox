
  CREATE UNIQUE INDEX "DIRKSPZM32"."IX_DW_BDE_PDOD_RES_TYP_ZEIT" ON "DIRKSPZM32"."DW_BDE_PROD_DATEN" ("RES_ID", "DW_BDE_TYP", "DW_BDE_DATUM_START") REVERSE 
  ;


-- sqlcl_snapshot {"hash":"87dfc64cb8437d3710248be95aa90dc6961794b4","type":"INDEX","name":"IX_DW_BDE_PDOD_RES_TYP_ZEIT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_BDE_PDOD_RES_TYP_ZEIT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_BDE_PROD_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DW_BDE_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DW_BDE_DATUM_START</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}