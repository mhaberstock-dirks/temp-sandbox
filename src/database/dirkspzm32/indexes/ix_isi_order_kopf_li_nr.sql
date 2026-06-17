
  CREATE INDEX "DIRKSPZM32"."IX_ISI_ORDER_KOPF_LI_NR" ON "DIRKSPZM32"."ISI_ORDER_KOPF" ("LI_NR", "VORGANG_ID") 
  ;


-- sqlcl_snapshot {"hash":"169e61966ee0280efc6d1113c5eac916e5784cf2","type":"INDEX","name":"IX_ISI_ORDER_KOPF_LI_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_KOPF_LI_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LI_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}