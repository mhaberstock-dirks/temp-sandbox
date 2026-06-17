
  CREATE INDEX "DIRKSPZM32"."IX_ZE_RESOURCE_IST_START" ON "DIRKSPZM32"."PZM_ZEITERFASSUNG" ("ZE_PERS_NR", "ZE_IST_START") 
  ;


-- sqlcl_snapshot {"hash":"2b3740036ff6aacdd8d41609f0e1f4e9f49d346f","type":"INDEX","name":"IX_ZE_RESOURCE_IST_START","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_RESOURCE_IST_START</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_IST_START</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}