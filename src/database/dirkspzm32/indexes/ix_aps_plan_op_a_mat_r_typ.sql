
  CREATE INDEX "IX_APS_PLAN_OP_A_MAT_R_TYP" ON "APS_PLAN_OP_A_MAT_RELATION" ("MATERIALRELATION_TYPE", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"b0cb09e6f7bb50a51d95c2d6ad4fd4aef68f14dc","type":"INDEX","name":"IX_APS_PLAN_OP_A_MAT_R_TYP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_OP_A_MAT_R_TYP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_OP_A_MAT_RELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MATERIALRELATION_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}