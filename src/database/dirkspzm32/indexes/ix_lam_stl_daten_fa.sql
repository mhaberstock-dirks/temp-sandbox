
  CREATE INDEX "DIRKSPZM32"."IX_LAM_STL_DATEN_FA" ON "DIRKSPZM32"."BDE_PD_LAM_STL_DATEN" ("FA_NR", "FA_AG", "FA_UPOS", "FERT_LAM_ID") 
  ;


-- sqlcl_snapshot {"hash":"9b49d40ca12ae002b6c51acfc3cfa853c7edd9b0","type":"INDEX","name":"IX_LAM_STL_DATEN_FA","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_STL_DATEN_FA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_LAM_STL_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FERT_LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}