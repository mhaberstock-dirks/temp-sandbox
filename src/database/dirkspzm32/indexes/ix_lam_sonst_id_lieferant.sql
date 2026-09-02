
  CREATE INDEX "IX_LAM_SONST_ID_LIEFERANT" ON "LVS_LAM" ("SONST_ID_LIEFERANT", "LAM_ID") 
  ;


-- sqlcl_snapshot {"hash":"6e54c6300b6f71cc7b40c036b2f461f1326bfe83","type":"INDEX","name":"IX_LAM_SONST_ID_LIEFERANT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_SONST_ID_LIEFERANT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SONST_ID_LIEFERANT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}