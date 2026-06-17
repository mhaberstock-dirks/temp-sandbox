
  CREATE INDEX "DIRKSPZM32"."IX_ISI_ORDER_KOPF_ORDER_DATUM" ON "DIRKSPZM32"."ISI_ORDER_KOPF" ("ORDER_DATUM", "VORGANG_TYP", "VORGANG_ID") 
  ;


-- sqlcl_snapshot {"hash":"1ef95d7b6f772b70d65175e41752bf2f89f27e67","type":"INDEX","name":"IX_ISI_ORDER_KOPF_ORDER_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_KOPF_ORDER_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}