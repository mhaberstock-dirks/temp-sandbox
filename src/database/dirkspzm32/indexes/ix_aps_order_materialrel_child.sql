
  CREATE INDEX "IX_APS_ORDER_MATERIALREL_CHILD" ON "APS_ORDER_MATERIALRELATION" ("CHILD_ID", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"2b300318d9b13d9763596742c38b24d545120386","type":"INDEX","name":"IX_APS_ORDER_MATERIALREL_CHILD","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_MATERIALREL_CHILD</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_MATERIALRELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}