
  CREATE INDEX "DIRKSPZM32"."IX_APS_PLAN_OP_A_MAT_R_CHILD" ON "DIRKSPZM32"."APS_PLAN_OP_A_MAT_RELATION" ("CHILD_ID", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"638641009898d667f56783bf5450437b6d969536","type":"INDEX","name":"IX_APS_PLAN_OP_A_MAT_R_CHILD","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_OP_A_MAT_R_CHILD</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_OP_A_MAT_RELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}