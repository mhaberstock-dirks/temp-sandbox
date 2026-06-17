
  CREATE INDEX "DIRKSPZM32"."IX_ISI_RES_SCHICHT_START_DATUM" ON "DIRKSPZM32"."ISI_RES_SCHICHT" ("START_DATE_TIME", "SID", "FIRMA_NR") 
  ;


-- sqlcl_snapshot {"hash":"2268f8622e89dbc80630472ff63f359f73d93eea","type":"INDEX","name":"IX_ISI_RES_SCHICHT_START_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_RES_SCHICHT_START_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_SCHICHT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>START_DATE_TIME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}