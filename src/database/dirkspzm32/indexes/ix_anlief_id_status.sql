
  CREATE INDEX "DIRKSPZM32"."IX_ANLIEF_ID_STATUS" ON "DIRKSPZM32"."LVS_ANLIEF_ID_LISTE" ("STATUS", "ANLIEF_ID") 
  ;


-- sqlcl_snapshot {"hash":"6baed28d1ed75072f26359d5fccd7b9fad6e779e","type":"INDEX","name":"IX_ANLIEF_ID_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ANLIEF_ID_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_ANLIEF_ID_LISTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ANLIEF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}