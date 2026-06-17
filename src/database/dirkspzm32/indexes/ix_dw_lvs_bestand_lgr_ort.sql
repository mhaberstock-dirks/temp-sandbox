
  CREATE INDEX "DIRKSPZM32"."IX_DW_LVS_BESTAND_LGR_ORT" ON "DIRKSPZM32"."DW_LVS_BESTAND" ("STAT_NAME", "ERFASST_AM", "LGR_ORT") 
  ;


-- sqlcl_snapshot {"hash":"e9510d0bde88193ca7a29429eece41ee02c3b655","type":"INDEX","name":"IX_DW_LVS_BESTAND_LGR_ORT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_LGR_ORT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}