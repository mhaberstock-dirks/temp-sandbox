
  CREATE INDEX "DIRKSPZM32"."IX_ISI_ORDER_KOPF_TYP_STATUS" ON "DIRKSPZM32"."ISI_ORDER_KOPF" ("VORGANG_TYP", "STATUS") 
  ;


-- sqlcl_snapshot {"hash":"e23fe25363c9cd247fe9bb59e7ad82a8269b3039","type":"INDEX","name":"IX_ISI_ORDER_KOPF_TYP_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_KOPF_TYP_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}