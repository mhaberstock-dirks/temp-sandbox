
  CREATE INDEX "DIRKSPZM32"."IX_APS_ORDER_MAT_REL_AUFTR_BWE" ON "DIRKSPZM32"."APS_ORDER_MATERIALRELATION" ("AUFTRAG_NR", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"e2000aa5935c4228e19ace383d0b1976051e73ea","type":"INDEX","name":"IX_APS_ORDER_MAT_REL_AUFTR_BWE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_MAT_REL_AUFTR_BWE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_MATERIALRELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUFTRAG_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}