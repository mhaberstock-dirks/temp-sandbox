
  CREATE INDEX "DIRKSPZM32"."IX_CAL_APPOINTMENTS_IX1" ON "DIRKSPZM32"."CAL_APPOINTMENTS" ("START_TIME", "END_TIME") 
  ;


-- sqlcl_snapshot {"hash":"de726be8ef6bd3fc14a0c8995d10e86b9c4ccba4","type":"INDEX","name":"IX_CAL_APPOINTMENTS_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_CAL_APPOINTMENTS_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>CAL_APPOINTMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>START_TIME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>END_TIME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}