
  CREATE INDEX "DIRKSPZM32"."IX_STUECKLISTE_STL_ID_ARTIKEL" ON "DIRKSPZM32"."PPS_STUECKLISTE_POS" ("STUECKLISTE_ID", "ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"2673797c427fd15fc2d08dd3f86d1487f50729ec","type":"INDEX","name":"IX_STUECKLISTE_STL_ID_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_STUECKLISTE_STL_ID_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_STUECKLISTE_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STUECKLISTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}