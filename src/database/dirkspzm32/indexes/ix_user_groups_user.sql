
  CREATE INDEX "DIRKSPZM32"."IX_USER_GROUPS_USER" ON "DIRKSPZM32"."SEC_USER_GROUPS" ("SID", "LOGIN_ID", "FIRMA_NR") 
  ;


-- sqlcl_snapshot {"hash":"5e0530b33fe22159aca9c3388cf1ea41097a343a","type":"INDEX","name":"IX_USER_GROUPS_USER","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_USER_GROUPS_USER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>SEC_USER_GROUPS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOGIN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}