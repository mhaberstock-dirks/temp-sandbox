
  CREATE INDEX "IX_APS_ORDER_AUFTR_POS_PS_ART" ON "APS_ORDER_AUFTR_POS" ("APS_PLAN_STATUS", "ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"ada86d2caaa2f5085e28c565c13b2868376670f0","type":"INDEX","name":"IX_APS_ORDER_AUFTR_POS_PS_ART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_AUFTR_POS_PS_ART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}