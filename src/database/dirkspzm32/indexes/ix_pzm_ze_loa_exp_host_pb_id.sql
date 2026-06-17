
  CREATE INDEX "DIRKSPZM32"."IX_PZM_ZE_LOA_EXP_HOST_PB_ID" ON "DIRKSPZM32"."PZM_ZE_LOA_EXP_HOST" ("PB_ID", "PERS_NR", "DATUM", "LOHNART") 
  ;


-- sqlcl_snapshot {"hash":"bb268c39a700a29cb2b465b115892e5d40e788db","type":"INDEX","name":"IX_PZM_ZE_LOA_EXP_HOST_PB_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PZM_ZE_LOA_EXP_HOST_PB_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_LOA_EXP_HOST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PB_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOHNART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}