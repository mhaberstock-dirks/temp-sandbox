
  CREATE INDEX "IX_S_RCV_DIS_TO_ORDER_VORGANG" ON "S_RCV_DIS_TO_ORDER" ("SATZART", "VORGANG_ID") 
  ;


-- sqlcl_snapshot {"hash":"e1f7979a359603ac4dca5aa4208425fee4aef48e","type":"INDEX","name":"IX_S_RCV_DIS_TO_ORDER_VORGANG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RCV_DIS_TO_ORDER_VORGANG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_DIS_TO_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SATZART</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}