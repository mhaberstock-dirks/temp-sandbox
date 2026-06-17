
  CREATE INDEX "DIRKSPZM32"."IX_ANLIEF_ID_LOGIN_ID" ON "DIRKSPZM32"."LVS_ANLIEF_ID_LISTE" ("LOGIN_ID", "ANLIEF_ID") 
  ;


-- sqlcl_snapshot {"hash":"fbb2a53667ca16c71b2522b82c4c6ae4fdcbcc2d","type":"INDEX","name":"IX_ANLIEF_ID_LOGIN_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ANLIEF_ID_LOGIN_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_ANLIEF_ID_LISTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOGIN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ANLIEF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}