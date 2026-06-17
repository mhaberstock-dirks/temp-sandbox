
  CREATE UNIQUE INDEX "DIRKSPZM32"."LOWER_USERNAME" ON "DIRKSPZM32"."ISI_USER" (LOWER("USERNAME")) 
  ;


-- sqlcl_snapshot {"hash":"d5c3dd2bacd49e8057d237a8e1fd899b949873ab","type":"INDEX","name":"LOWER_USERNAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>LOWER_USERNAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_USER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOWER(\"USERNAME\")</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}