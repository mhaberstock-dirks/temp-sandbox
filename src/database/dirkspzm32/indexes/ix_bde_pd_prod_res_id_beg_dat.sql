
  CREATE INDEX "DIRKSPZM32"."IX_BDE_PD_PROD_RES_ID_BEG_DAT" ON "DIRKSPZM32"."BDE_PD_PROD" ("RES_ID", "VORG_TYP", "PROD_BEGINN") 
  ;


-- sqlcl_snapshot {"hash":"a588891a9f661de6990cb60540fea01840bf2238","type":"INDEX","name":"IX_BDE_PD_PROD_RES_ID_BEG_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROD_RES_ID_BEG_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROD_BEGINN</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}