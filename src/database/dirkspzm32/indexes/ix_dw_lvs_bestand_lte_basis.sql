
  CREATE INDEX "DIRKSPZM32"."IX_DW_LVS_BESTAND_LTE_BASIS" ON "DIRKSPZM32"."DW_LVS_BESTAND" ("ERFASST_AM", "STAT_NAME", "BASIS_LTE_NAME") 
  ;


-- sqlcl_snapshot {"hash":"55f7e718e763840dec892ee3e5718d9a0e5462d2","type":"INDEX","name":"IX_DW_LVS_BESTAND_LTE_BASIS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_LTE_BASIS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BASIS_LTE_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}