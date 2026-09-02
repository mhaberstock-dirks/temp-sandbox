
  CREATE INDEX "IX_ISI_ORDER_KOPF_LI_NR" ON "ISI_ORDER_KOPF" ("LI_NR", "VORGANG_ID") 
  ;


-- sqlcl_snapshot {"hash":"a6ee0ef7854fb16d68d6b765e8ce1d6955c578da","type":"INDEX","name":"IX_ISI_ORDER_KOPF_LI_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_KOPF_LI_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LI_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}