
  CREATE INDEX "IX_ARTIKEL_CTRL_FUNKTION" ON "ISI_ARTIKEL_CTRL" ("FUNKTION", "ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"d19d1d9d1b35a94157046938cba4c0e2578cc286","type":"INDEX","name":"IX_ARTIKEL_CTRL_FUNKTION","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ARTIKEL_CTRL_FUNKTION</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_CTRL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FUNKTION</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}