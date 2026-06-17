
  CREATE UNIQUE INDEX "DIRKSPZM32"."VIEWPORT_NAME" ON "DIRKSPZM32"."MFR_VIEWPORTS_CFG" ("VIEWPORT_NAME", "VIEWPORT_SCOPE") 
  ;


-- sqlcl_snapshot {"hash":"ac460455f8a7ab6b9cb090070ea4eeb83fec23ea","type":"INDEX","name":"VIEWPORT_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>VIEWPORT_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MFR_VIEWPORTS_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VIEWPORT_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VIEWPORT_SCOPE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}