
  CREATE UNIQUE INDEX "DIRKSPZM32"."IX_APS_PLAN_ERGEBNIS" ON "DIRKSPZM32"."APS_PLAN_ERGEBNIS" ("APS_PLAN_AUFTRAG_NR", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"76ab43b6ebd9ea3c3737b22a2d1f8c7754776bf3","type":"INDEX","name":"IX_APS_PLAN_ERGEBNIS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_ERGEBNIS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_ERGEBNIS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_AUFTRAG_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}