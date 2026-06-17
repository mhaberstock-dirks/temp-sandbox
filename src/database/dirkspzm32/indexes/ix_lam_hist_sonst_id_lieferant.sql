
  CREATE INDEX "DIRKSPZM32"."IX_LAM_HIST_SONST_ID_LIEFERANT" ON "DIRKSPZM32"."LVS_LAM_HIST" ("SONST_ID_LIEFERANT", "LAM_ID") 
  ;


-- sqlcl_snapshot {"hash":"f87c299dafe8951bb26bbc0f49e5a6e5d4c22f7c","type":"INDEX","name":"IX_LAM_HIST_SONST_ID_LIEFERANT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_HIST_SONST_ID_LIEFERANT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SONST_ID_LIEFERANT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}