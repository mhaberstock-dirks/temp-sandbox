
  CREATE INDEX "DIRKSPZM32"."IX_SEND_BEW_LTE_NR_STATUS" ON "DIRKSPZM32"."S_SEND_BEW" ("LTE_NR", "STATUS") 
  ;


-- sqlcl_snapshot {"hash":"3cb8e16b8f932fc0de8d2daf624e24998acbd887","type":"INDEX","name":"IX_SEND_BEW_LTE_NR_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_SEND_BEW_LTE_NR_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}