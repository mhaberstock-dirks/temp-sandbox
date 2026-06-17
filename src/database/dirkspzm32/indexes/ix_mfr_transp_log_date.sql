
  CREATE INDEX "DIRKSPZM32"."IX_MFR_TRANSP_LOG_DATE" ON "DIRKSPZM32"."MFR_TRANSP_LOG" ("LOG_DATE", "ELEMENT") 
  ;


-- sqlcl_snapshot {"hash":"f4c3b5d7c4989ef90c57a46f86ebd097768d19ed","type":"INDEX","name":"IX_MFR_TRANSP_LOG_DATE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MFR_TRANSP_LOG_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MFR_TRANSP_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOG_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ELEMENT</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}