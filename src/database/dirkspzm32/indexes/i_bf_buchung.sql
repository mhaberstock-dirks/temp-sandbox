
  CREATE INDEX "DIRKSPZM32"."I_BF_BUCHUNG" ON "DIRKSPZM32"."S_HUF_SEND_BEW" ("STATUS", "TEILE_NR", "MELDE_POS") 
  ;


-- sqlcl_snapshot {"hash":"e60931c10e75407ea226995dfd27823df33633df","type":"INDEX","name":"I_BF_BUCHUNG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>I_BF_BUCHUNG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_HUF_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TEILE_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MELDE_POS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}