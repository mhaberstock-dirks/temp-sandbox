
  CREATE INDEX "DIRKSPZM32"."IX_KOMM_ORDER_STATUS" ON "DIRKSPZM32"."ISI_KOMM_ORDER" ("STATUS", "KOMM_ID") 
  ;


-- sqlcl_snapshot {"hash":"2913b0b8b574568582d86deb5356f8157735e658","type":"INDEX","name":"IX_KOMM_ORDER_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_ORDER_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}