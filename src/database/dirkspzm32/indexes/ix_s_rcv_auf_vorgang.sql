
  CREATE INDEX "DIRKSPZM32"."IX_S_RCV_AUF_VORGANG" ON "DIRKSPZM32"."S_RCV_AUFTR" ("SATZART", "VORGANG") 
  ;


-- sqlcl_snapshot {"hash":"16592a76d2a7a49c01e6f165d6b07c46172201a1","type":"INDEX","name":"IX_S_RCV_AUF_VORGANG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RCV_AUF_VORGANG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_AUFTR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SATZART</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}