
  CREATE INDEX "IX_ISI_SCAN_LOG_STATUS_LHM_ID" ON "ISI_SCAN_LOG" ("SCAN_OK", "LHM_ID") 
  ;


-- sqlcl_snapshot {"hash":"548e6b256e42aaa8cdf9b88c0181ad04cca02431","type":"INDEX","name":"IX_ISI_SCAN_LOG_STATUS_LHM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_SCAN_LOG_STATUS_LHM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_SCAN_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SCAN_OK</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}