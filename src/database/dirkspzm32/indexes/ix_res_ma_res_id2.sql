
  CREATE INDEX "DIRKSPZM32"."IX_RES_MA_RES_ID2" ON "DIRKSPZM32"."ISI_RES_MAGAZIN" ("MA_RES_ID", "FIRMA_NR", "SID") 
  ;


-- sqlcl_snapshot {"hash":"9bbfa01210e3e6d1b0a44b0defe3648d14ac7556","type":"INDEX","name":"IX_RES_MA_RES_ID2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_MA_RES_ID2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_MAGAZIN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MA_RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}