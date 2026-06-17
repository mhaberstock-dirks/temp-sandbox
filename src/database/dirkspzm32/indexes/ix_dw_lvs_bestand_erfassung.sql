
  CREATE INDEX "DIRKSPZM32"."IX_DW_LVS_BESTAND_ERFASSUNG" ON "DIRKSPZM32"."DW_LVS_BESTAND" ("ERFASST_AM", "STAT_NAME") 
  ;


-- sqlcl_snapshot {"hash":"62ae2da0b12a3077bec5c7ed7008d4ada2c23e6b","type":"INDEX","name":"IX_DW_LVS_BESTAND_ERFASSUNG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_ERFASSUNG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}