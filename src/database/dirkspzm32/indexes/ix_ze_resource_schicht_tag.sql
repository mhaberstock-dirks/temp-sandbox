
  CREATE INDEX "DIRKSPZM32"."IX_ZE_RESOURCE_SCHICHT_TAG" ON "DIRKSPZM32"."PZM_ZEITERFASSUNG" ("ZE_PERS_NR", "ZE_SCHICHT_TAG") 
  ;


-- sqlcl_snapshot {"hash":"a8559bc402a0ef39089350ccbff75598459def3f","type":"INDEX","name":"IX_ZE_RESOURCE_SCHICHT_TAG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_RESOURCE_SCHICHT_TAG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_SCHICHT_TAG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}