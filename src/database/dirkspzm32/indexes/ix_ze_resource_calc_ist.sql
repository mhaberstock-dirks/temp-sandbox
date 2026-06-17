
  CREATE INDEX "DIRKSPZM32"."IX_ZE_RESOURCE_CALC_IST" ON "DIRKSPZM32"."PZM_ZEITERFASSUNG" ("ZE_PERS_NR", "ZE_CALC_IST_START", "ZE_CALC_IST_ENDE") 
  ;


-- sqlcl_snapshot {"hash":"28e165e0df34cab4349c4a53f32b1d88c7d2843d","type":"INDEX","name":"IX_ZE_RESOURCE_CALC_IST","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_RESOURCE_CALC_IST</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_CALC_IST_START</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_CALC_IST_ENDE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}