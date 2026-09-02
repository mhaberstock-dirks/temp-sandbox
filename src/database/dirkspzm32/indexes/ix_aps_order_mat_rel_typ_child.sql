
  CREATE INDEX "IX_APS_ORDER_MAT_REL_TYP_CHILD" ON "APS_ORDER_MATERIALRELATION" ("MATERIALRELATION_TYPE", "CHILD_ID", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"01b3f805a8c2f727305a73e934e2504df5c59d58","type":"INDEX","name":"IX_APS_ORDER_MAT_REL_TYP_CHILD","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_MAT_REL_TYP_CHILD</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_MATERIALRELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MATERIALRELATION_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}