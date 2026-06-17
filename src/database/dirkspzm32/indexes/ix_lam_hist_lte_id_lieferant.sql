
  CREATE INDEX "DIRKSPZM32"."IX_LAM_HIST_LTE_ID_LIEFERANT" ON "DIRKSPZM32"."LVS_LAM_HIST" ("LTE_ID_LIEFERANT", "LAM_ID") 
  ;


-- sqlcl_snapshot {"hash":"dfe7f428776067165c95e78afe8b6af6e2d5f976","type":"INDEX","name":"IX_LAM_HIST_LTE_ID_LIEFERANT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_HIST_LTE_ID_LIEFERANT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID_LIEFERANT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}