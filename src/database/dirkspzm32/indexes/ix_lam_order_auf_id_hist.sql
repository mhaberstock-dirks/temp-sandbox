
  CREATE INDEX "DIRKSPZM32"."IX_LAM_ORDER_AUF_ID_HIST" ON "DIRKSPZM32"."LVS_LAM_HIST" ("SID", "ORDER_POS_AUF_ID") 
  ;


-- sqlcl_snapshot {"hash":"a0a4d6efb1c4c8a97b054bf2d38d3ffefd776a69","type":"INDEX","name":"IX_LAM_ORDER_AUF_ID_HIST","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_ORDER_AUF_ID_HIST</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_POS_AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}