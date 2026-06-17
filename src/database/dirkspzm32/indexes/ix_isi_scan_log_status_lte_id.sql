
  CREATE INDEX "DIRKSPZM32"."IX_ISI_SCAN_LOG_STATUS_LTE_ID" ON "DIRKSPZM32"."ISI_SCAN_LOG" ("SCAN_OK", "LTE_ID") 
  ;


-- sqlcl_snapshot {"hash":"fbb5e8ddc26564ba246ad098b6a41932612bdfc5","type":"INDEX","name":"IX_ISI_SCAN_LOG_STATUS_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_SCAN_LOG_STATUS_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_SCAN_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SCAN_OK</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}