
  CREATE INDEX "DIRKSPZM32"."IX_BDE_PD_PROD_LAM_VORG_TYP_ID" ON "DIRKSPZM32"."BDE_PD_PROD" ("VORG_TYP", "LAM_ID", "VORG_ID") 
  ;


-- sqlcl_snapshot {"hash":"da15a4d8e0d75b8cec912b5c877cf4015c228a27","type":"INDEX","name":"IX_BDE_PD_PROD_LAM_VORG_TYP_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROD_LAM_VORG_TYP_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}