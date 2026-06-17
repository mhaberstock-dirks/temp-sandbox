
  CREATE INDEX "DIRKSPZM32"."IX_ZE_AA_STATUS" ON "DIRKSPZM32"."PZM_ZEITERFASSUNG" ("ZE_AA_STATUS", "ZE_ID") 
  ;


-- sqlcl_snapshot {"hash":"5844875e9265046b7c8ef771380db77a00d4bbb0","type":"INDEX","name":"IX_ZE_AA_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_AA_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_AA_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}