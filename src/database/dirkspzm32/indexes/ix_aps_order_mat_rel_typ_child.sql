
  CREATE INDEX "DIRKSPZM32"."IX_APS_ORDER_MAT_REL_TYP_CHILD" ON "DIRKSPZM32"."APS_ORDER_MATERIALRELATION" ("MATERIALRELATION_TYPE", "CHILD_ID", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"7c261de1c90d4f4003b23f72ec359ba9b83ec079","type":"INDEX","name":"IX_APS_ORDER_MAT_REL_TYP_CHILD","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_MAT_REL_TYP_CHILD</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_MATERIALRELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MATERIALRELATION_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}