
  CREATE UNIQUE INDEX "VIEWPORT_NAME" ON "MFR_VIEWPORTS_CFG" ("VIEWPORT_NAME", "VIEWPORT_SCOPE") 
  ;


-- sqlcl_snapshot {"hash":"61a51f4e1389426cbf431af484f16e654cd08dc2","type":"INDEX","name":"VIEWPORT_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>VIEWPORT_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MFR_VIEWPORTS_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VIEWPORT_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VIEWPORT_SCOPE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}