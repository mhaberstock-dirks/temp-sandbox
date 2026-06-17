
  CREATE INDEX "DIRKSPZM32"."IX_AKTIVE_ARTIKEL" ON "DIRKSPZM32"."ISI_ARTIKEL" ("AKTIV", "ARTIKEL") 
  ;


-- sqlcl_snapshot {"hash":"5921506dcca3443231ae1bb954e5d0ba53363fa9","type":"INDEX","name":"IX_AKTIVE_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_AKTIVE_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AKTIV</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}