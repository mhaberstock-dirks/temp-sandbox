
  CREATE INDEX "DIRKSPZM32"."IX_APS_PLAN_OP_A_MAT_R_C_ART" ON "DIRKSPZM32"."APS_PLAN_OP_A_MAT_RELATION" ("APS_PLAN_STATUS", "CHILD_ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"c11dd66bbdba278b57adff7756f5cdb70a1bca13","type":"INDEX","name":"IX_APS_PLAN_OP_A_MAT_R_C_ART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_OP_A_MAT_R_C_ART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_OP_A_MAT_RELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}