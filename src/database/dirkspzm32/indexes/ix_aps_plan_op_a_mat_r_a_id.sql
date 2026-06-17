
  CREATE INDEX "DIRKSPZM32"."IX_APS_PLAN_OP_A_MAT_R_A_ID" ON "DIRKSPZM32"."APS_PLAN_OP_A_MAT_RELATION" ("APS_PLAN_STATUS", "ACTIVITY_ID") 
  ;


-- sqlcl_snapshot {"hash":"44828bc25f696e8a4f51cef03d3ff39720674506","type":"INDEX","name":"IX_APS_PLAN_OP_A_MAT_R_A_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_OP_A_MAT_R_A_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_OP_A_MAT_RELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACTIVITY_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}