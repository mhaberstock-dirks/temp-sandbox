
  CREATE INDEX "IX_MDE_STATISTIK_NAME_DATUM" ON "MDE_STATISTIK" ("NAME", "DATUM") 
  ;


-- sqlcl_snapshot {"hash":"1a8d1fac62e4cbe483651c566d79fa25a35e121e","type":"INDEX","name":"IX_MDE_STATISTIK_NAME_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MDE_STATISTIK_NAME_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MDE_STATISTIK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}