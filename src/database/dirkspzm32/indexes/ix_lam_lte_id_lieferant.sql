
  CREATE INDEX "IX_LAM_LTE_ID_LIEFERANT" ON "LVS_LAM" ("LTE_ID_LIEFERANT", "LAM_ID") 
  ;


-- sqlcl_snapshot {"hash":"e60d41708cb2561a1b7e8c3382c099dff43639c5","type":"INDEX","name":"IX_LAM_LTE_ID_LIEFERANT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_LTE_ID_LIEFERANT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID_LIEFERANT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}