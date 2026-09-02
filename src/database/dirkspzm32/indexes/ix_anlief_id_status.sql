
  CREATE INDEX "IX_ANLIEF_ID_STATUS" ON "LVS_ANLIEF_ID_LISTE" ("STATUS", "ANLIEF_ID") 
  ;


-- sqlcl_snapshot {"hash":"80d447a1ea78358a0ca910ea5150e4d32c01f398","type":"INDEX","name":"IX_ANLIEF_ID_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ANLIEF_ID_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_ANLIEF_ID_LISTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ANLIEF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}