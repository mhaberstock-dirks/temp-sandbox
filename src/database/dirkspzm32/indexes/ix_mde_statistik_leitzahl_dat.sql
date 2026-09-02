
  CREATE INDEX "IX_MDE_STATISTIK_LEITZAHL_DAT" ON "MDE_STATISTIK" ("LEITZAHL", "DATUM") 
  ;


-- sqlcl_snapshot {"hash":"55fa5bd255b9b572611f5f7fd2c90d48cf2b25d1","type":"INDEX","name":"IX_MDE_STATISTIK_LEITZAHL_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MDE_STATISTIK_LEITZAHL_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MDE_STATISTIK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}