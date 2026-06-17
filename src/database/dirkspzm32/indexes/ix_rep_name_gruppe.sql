
  CREATE INDEX "DIRKSPZM32"."IX_REP_NAME_GRUPPE" ON "DIRKSPZM32"."REP_ABFRAGEN" (UPPER("REP_NAME"), UPPER("REP_GRUPPE")) 
  ;


-- sqlcl_snapshot {"hash":"1953d5d7816ebf4b64f45224249ea67e61bf6441","type":"INDEX","name":"IX_REP_NAME_GRUPPE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_REP_NAME_GRUPPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>REP_ABFRAGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>UPPER(\"REP_NAME\")</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPPER(\"REP_GRUPPE\")</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}