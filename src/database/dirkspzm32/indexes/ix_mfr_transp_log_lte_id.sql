
  CREATE INDEX "IX_MFR_TRANSP_LOG_LTE_ID" ON "MFR_TRANSP_LOG" ("LTE_ID", "LOG_DATE") 
  ;


-- sqlcl_snapshot {"hash":"85903e06022395ac66bdfb39ad3dad9a9bb9d5f3","type":"INDEX","name":"IX_MFR_TRANSP_LOG_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MFR_TRANSP_LOG_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MFR_TRANSP_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOG_DATE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}