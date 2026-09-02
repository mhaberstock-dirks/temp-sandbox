
  CREATE INDEX "IX_PERS_NR_BEGINN" ON "PZM_ABWESENHEITSMELDUNGEN" ("PERS_NR", "BEGINN") 
  ;


-- sqlcl_snapshot {"hash":"3aa1398ee9fb3ce66821c6f5aa67a6a47dec898a","type":"INDEX","name":"IX_PERS_NR_BEGINN","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PERS_NR_BEGINN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ABWESENHEITSMELDUNGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEGINN</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}