
  CREATE INDEX "DIRKSPZM32"."IX_PURCH_KOPF_IX3" ON "DIRKSPZM32"."ISI_PURCH_KOPF" ("LIEFER_DATUM", "VORG_TYP", "STATUS") 
  ;


-- sqlcl_snapshot {"hash":"d840b1c945daebf6ab8fa8f10982dc89f719e155","type":"INDEX","name":"IX_PURCH_KOPF_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PURCH_KOPF_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_PURCH_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LIEFER_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}