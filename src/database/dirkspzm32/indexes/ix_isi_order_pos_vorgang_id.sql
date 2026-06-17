
  CREATE INDEX "DIRKSPZM32"."IX_ISI_ORDER_POS_VORGANG_ID" ON "DIRKSPZM32"."ISI_ORDER_POS" ("VORGANG_ID", "VORGANG_TYP", "AUF_ID") 
  ;


-- sqlcl_snapshot {"hash":"3b762d4ee5578af139d6760a6ab6537b924d1c85","type":"INDEX","name":"IX_ISI_ORDER_POS_VORGANG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_VORGANG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}