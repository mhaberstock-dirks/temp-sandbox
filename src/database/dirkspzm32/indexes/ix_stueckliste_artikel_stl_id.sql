
  CREATE INDEX "DIRKSPZM32"."IX_STUECKLISTE_ARTIKEL_STL_ID" ON "DIRKSPZM32"."PPS_STUECKLISTE_POS" ("ARTIKEL_ID", "STUECKLISTE_ID") 
  ;


-- sqlcl_snapshot {"hash":"7c84f9076004d039ab22abba7790f4c1751ebd6d","type":"INDEX","name":"IX_STUECKLISTE_ARTIKEL_STL_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_STUECKLISTE_ARTIKEL_STL_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_STUECKLISTE_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STUECKLISTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}