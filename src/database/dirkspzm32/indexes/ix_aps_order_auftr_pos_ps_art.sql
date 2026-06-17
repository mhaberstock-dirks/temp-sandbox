
  CREATE INDEX "DIRKSPZM32"."IX_APS_ORDER_AUFTR_POS_PS_ART" ON "DIRKSPZM32"."APS_ORDER_AUFTR_POS" ("APS_PLAN_STATUS", "ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"891d2d71e68d695119b742f0221198169ebb6f0d","type":"INDEX","name":"IX_APS_ORDER_AUFTR_POS_PS_ART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_AUFTR_POS_PS_ART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}