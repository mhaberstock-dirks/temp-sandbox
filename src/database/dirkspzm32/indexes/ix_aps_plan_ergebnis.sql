
  CREATE UNIQUE INDEX "IX_APS_PLAN_ERGEBNIS" ON "APS_PLAN_ERGEBNIS" ("APS_PLAN_AUFTRAG_NR", "APS_PLAN_STATUS") 
  ;


-- sqlcl_snapshot {"hash":"60cfdcf1dc1c711ae67d6df591bfcb5ce5754d0d","type":"INDEX","name":"IX_APS_PLAN_ERGEBNIS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_ERGEBNIS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_ERGEBNIS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_AUFTRAG_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}