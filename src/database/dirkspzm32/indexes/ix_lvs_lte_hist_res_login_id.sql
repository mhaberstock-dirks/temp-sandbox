
  CREATE INDEX "IX_LVS_LTE_HIST_RES_LOGIN_ID" ON "LVS_LTE_HIST" ("RES_LOGIN_ID", "LTE_ID") 
  ;


-- sqlcl_snapshot {"hash":"841483512d2c1d617e878c8e73521418afe513f7","type":"INDEX","name":"IX_LVS_LTE_HIST_RES_LOGIN_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_RES_LOGIN_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_LOGIN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}