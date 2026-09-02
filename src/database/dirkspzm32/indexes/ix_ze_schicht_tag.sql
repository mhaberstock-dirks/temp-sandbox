
  CREATE INDEX "IX_ZE_SCHICHT_TAG" ON "PZM_ZEITERFASSUNG" ("ZE_SCHICHT_TAG", "ZE_ID") 
  ;


-- sqlcl_snapshot {"hash":"0cf6582a5bf781f71d1a96fc34461b1dd340e5a9","type":"INDEX","name":"IX_ZE_SCHICHT_TAG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_SCHICHT_TAG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_SCHICHT_TAG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}