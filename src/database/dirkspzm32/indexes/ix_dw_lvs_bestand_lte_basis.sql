
  CREATE INDEX "IX_DW_LVS_BESTAND_LTE_BASIS" ON "DW_LVS_BESTAND" ("ERFASST_AM", "STAT_NAME", "BASIS_LTE_NAME") 
  ;


-- sqlcl_snapshot {"hash":"cbaa06ca79ee2e415972768f393571cba76d7fc5","type":"INDEX","name":"IX_DW_LVS_BESTAND_LTE_BASIS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_LTE_BASIS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BASIS_LTE_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}