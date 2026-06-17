
  CREATE INDEX "DIRKSPZM32"."IX_MDE_STATISTIK_NAME_DATUM" ON "DIRKSPZM32"."MDE_STATISTIK" ("NAME", "DATUM") 
  ;


-- sqlcl_snapshot {"hash":"99e168c70e486cba56bf7734954674d9e0589725","type":"INDEX","name":"IX_MDE_STATISTIK_NAME_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MDE_STATISTIK_NAME_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MDE_STATISTIK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}