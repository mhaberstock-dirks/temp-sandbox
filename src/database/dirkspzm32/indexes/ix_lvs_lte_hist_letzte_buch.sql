
  CREATE INDEX "DIRKSPZM32"."IX_LVS_LTE_HIST_LETZTE_BUCH" ON "DIRKSPZM32"."LVS_LTE_HIST" ("SID", "FIRMA_NR", "LTE_LETZTE_BUCHUNG") 
  ;


-- sqlcl_snapshot {"hash":"2d7c61b89cacdec8e4f8fad319717ad5cfa53a52","type":"INDEX","name":"IX_LVS_LTE_HIST_LETZTE_BUCH","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_LETZTE_BUCH</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_LETZTE_BUCHUNG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}