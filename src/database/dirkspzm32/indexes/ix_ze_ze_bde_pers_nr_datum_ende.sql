
  CREATE INDEX "DIRKSPZM32"."IX_ZE_ZE_BDE_PERS_NR_DATUM_ENDE" ON "DIRKSPZM32"."PZM_ZE_BDE_ZEITEN" ("ZE_BDE_PERS_NR", "ZE_BDE_BASIS", "ZE_BDE_DAY_IST_ENDE") 
  ;


-- sqlcl_snapshot {"hash":"43f97adee658ce6712ccb38db49ea4ec0ce42990","type":"INDEX","name":"IX_ZE_ZE_BDE_PERS_NR_DATUM_ENDE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_ZE_BDE_PERS_NR_DATUM_ENDE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_BDE_ZEITEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_BASIS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_DAY_IST_ENDE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}