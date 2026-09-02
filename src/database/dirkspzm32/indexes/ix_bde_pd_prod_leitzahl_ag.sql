
  CREATE INDEX "IX_BDE_PD_PROD_LEITZAHL_AG" ON "BDE_PD_PROD" ("LEITZAHL", "FA_AG") 
  ;


-- sqlcl_snapshot {"hash":"f28318e6539486a3a8fecef61b5a0e07cf7fc3a5","type":"INDEX","name":"IX_BDE_PD_PROD_LEITZAHL_AG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROD_LEITZAHL_AG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}