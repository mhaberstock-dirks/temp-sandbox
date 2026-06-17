
  CREATE INDEX "DIRKSPZM32"."IX_RES_ENDE_BEG" ON "DIRKSPZM32"."ISI_RES_STATUS" ("RES_ID", "ST_ENDE", "ST_START") 
  ;


-- sqlcl_snapshot {"hash":"f9711b609e2e7707249a56d367ecfb4279fd8315","type":"INDEX","name":"IX_RES_ENDE_BEG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_ENDE_BEG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_STATUS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ST_ENDE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ST_START</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}