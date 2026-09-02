
  CREATE INDEX "IX_KOMM_ORDER_VORG_ID" ON "ISI_KOMM_ORDER" ("VORGANG_ID") 
  ;


-- sqlcl_snapshot {"hash":"d91d3456bdb667ac709372acd77d3b691a2e5ba4","type":"INDEX","name":"IX_KOMM_ORDER_VORG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_ORDER_VORG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}