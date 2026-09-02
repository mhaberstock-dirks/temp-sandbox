
  CREATE INDEX "IX_STUECKLISTE_ARTIKEL_STL_ID" ON "PPS_STUECKLISTE_POS" ("ARTIKEL_ID", "STUECKLISTE_ID") 
  ;


-- sqlcl_snapshot {"hash":"c5e9bc05f949886cc2e7c434ef0a2498a687912e","type":"INDEX","name":"IX_STUECKLISTE_ARTIKEL_STL_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_STUECKLISTE_ARTIKEL_STL_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_STUECKLISTE_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STUECKLISTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}