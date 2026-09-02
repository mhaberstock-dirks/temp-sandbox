
  CREATE INDEX "IX_APS_PLAN_OP_A_MAT_R_CHILD" ON "APS_PLAN_OP_A_MAT_RELATION" ("CHILD_ID", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"93a00ce414b67bf85704e27ca44381d138ddf994","type":"INDEX","name":"IX_APS_PLAN_OP_A_MAT_R_CHILD","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_OP_A_MAT_R_CHILD</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_OP_A_MAT_RELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}