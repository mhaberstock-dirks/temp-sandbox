
  CREATE INDEX "DIRKSPZM32"."IX_DW_LVS_BESTAND_LTE_NAME" ON "DIRKSPZM32"."DW_LVS_BESTAND" ("ERFASST_AM", "LTE_NAME", "STAT_NAME") 
  ;


-- sqlcl_snapshot {"hash":"98cee0ea7a11ca4e837c8060e36c7a414f04b9fa","type":"INDEX","name":"IX_DW_LVS_BESTAND_LTE_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_LTE_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}