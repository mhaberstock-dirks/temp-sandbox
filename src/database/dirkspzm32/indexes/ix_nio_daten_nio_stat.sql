
  CREATE INDEX "DIRKSPZM32"."IX_NIO_DATEN_NIO_STAT" ON "DIRKSPZM32"."BDE_PD_NIO_DATEN" ("NIO_STATUS", "NIO_NR") 
  ;


-- sqlcl_snapshot {"hash":"c9ec8b8537600d92ce5a12372c89951e1cceb13e","type":"INDEX","name":"IX_NIO_DATEN_NIO_STAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_NIO_DATEN_NIO_STAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_NIO_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NIO_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NIO_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}