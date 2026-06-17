
  CREATE INDEX "DIRKSPZM32"."IX_DW_LVS_BESTAND_ARTIKEL_ID" ON "DIRKSPZM32"."DW_LVS_BESTAND" ("ARTIKEL_ID", "ERFASST_AM", "STAT_NAME") 
  ;


-- sqlcl_snapshot {"hash":"93ea9e75657727897bc44cd8888a58325db91ea3","type":"INDEX","name":"IX_DW_LVS_BESTAND_ARTIKEL_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_ARTIKEL_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}