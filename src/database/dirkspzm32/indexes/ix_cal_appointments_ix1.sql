
  CREATE INDEX "IX_CAL_APPOINTMENTS_IX1" ON "CAL_APPOINTMENTS" ("START_TIME", "END_TIME") 
  ;


-- sqlcl_snapshot {"hash":"4c31a02633aad42aebaff2b7a65f50f2ef042002","type":"INDEX","name":"IX_CAL_APPOINTMENTS_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_CAL_APPOINTMENTS_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>CAL_APPOINTMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>START_TIME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>END_TIME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}