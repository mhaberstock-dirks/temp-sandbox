
  CREATE INDEX "IX_DW_LVS_BESTAND_STAT_TYP" ON "DW_LVS_BESTAND" ("STAT_NAME", "ERFASST_AM") 
  ;


-- sqlcl_snapshot {"hash":"c74859d26e07c10b57e3e8ea7f1ec2a981306442","type":"INDEX","name":"IX_DW_LVS_BESTAND_STAT_TYP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_STAT_TYP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}