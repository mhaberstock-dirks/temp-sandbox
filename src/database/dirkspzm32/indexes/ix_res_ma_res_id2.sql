
  CREATE INDEX "IX_RES_MA_RES_ID2" ON "ISI_RES_MAGAZIN" ("MA_RES_ID", "FIRMA_NR", "SID") 
  ;


-- sqlcl_snapshot {"hash":"c478b4c9db9135e17ffccf32bcb1c8ebb86faa8c","type":"INDEX","name":"IX_RES_MA_RES_ID2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_MA_RES_ID2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_MAGAZIN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MA_RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}