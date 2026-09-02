
  CREATE INDEX "IX_APS_PLAN_OP_A_MAT_R_A_ID" ON "APS_PLAN_OP_A_MAT_RELATION" ("APS_PLAN_STATUS", "ACTIVITY_ID") 
  ;


-- sqlcl_snapshot {"hash":"b2ded63d1b47cce6336ce498ddf5cdd36340f7a7","type":"INDEX","name":"IX_APS_PLAN_OP_A_MAT_R_A_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_OP_A_MAT_R_A_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_OP_A_MAT_RELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ACTIVITY_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}