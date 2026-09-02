
  CREATE INDEX "IX_KOMM_ORDER_KOMM_TYP" ON "ISI_KOMM_ORDER" ("KOMM_TYP", "KOMM_ID") 
  ;


-- sqlcl_snapshot {"hash":"52dd02fea1aadffd6162dcf8dfbed0f7d22918b5","type":"INDEX","name":"IX_KOMM_ORDER_KOMM_TYP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_ORDER_KOMM_TYP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}