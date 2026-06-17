
  CREATE INDEX "DIRKSPZM32"."IX_USER_GROUPS_GROUP" ON "DIRKSPZM32"."SEC_USER_GROUPS" ("SID", "GROUP_ID", "FIRMA_NR") 
  ;


-- sqlcl_snapshot {"hash":"9a014421ac4476c157c5b8ba78bb27af533dbb57","type":"INDEX","name":"IX_USER_GROUPS_GROUP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_USER_GROUPS_GROUP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>SEC_USER_GROUPS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GROUP_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}