
  CREATE INDEX "DIRKSPZM32"."IX_PE_JOBS_IX2" ON "DIRKSPZM32"."PE_JOBS" ("JOB_TIMESTAMP", "JOB_NR") 
  ;


-- sqlcl_snapshot {"hash":"fbd65dc8a7d93d1041b243fdd3ae24d801611ee0","type":"INDEX","name":"IX_PE_JOBS_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PE_JOBS_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PE_JOBS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>JOB_TIMESTAMP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>JOB_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}