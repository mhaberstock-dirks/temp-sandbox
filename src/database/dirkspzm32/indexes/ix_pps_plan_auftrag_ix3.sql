
  CREATE INDEX "IX_PPS_PLAN_AUFTRAG_IX3" ON "PPS_PLAN_AUFTRAG" ("ARTIKEL_ID", "ZEICHNUNG_INDEX", "ZEICHNUNG") 
  ;


-- sqlcl_snapshot {"hash":"790bcecc176a61ce6e6ba2027abefb6ea4bc8c69","type":"INDEX","name":"IX_PPS_PLAN_AUFTRAG_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_PLAN_AUFTRAG_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_PLAN_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZEICHNUNG_INDEX</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZEICHNUNG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}