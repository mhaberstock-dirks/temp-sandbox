
  CREATE INDEX "DIRKSPZM32"."IX_S_RCV_DIS_TO_ORDER_VORGANG" ON "DIRKSPZM32"."S_RCV_DIS_TO_ORDER" ("SATZART", "VORGANG_ID") 
  ;


-- sqlcl_snapshot {"hash":"9792b5521cd0f17aa9833679c6ecdd4e22dee43f","type":"INDEX","name":"IX_S_RCV_DIS_TO_ORDER_VORGANG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RCV_DIS_TO_ORDER_VORGANG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_DIS_TO_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SATZART</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}