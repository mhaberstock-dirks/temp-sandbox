
  CREATE INDEX "IX_BDE_PD_PROZESS_DATA_FAE_ID" ON "BDE_PD_PROZESS_DATA" ("FAE_ID", "LEITZAHL") 
  ;


-- sqlcl_snapshot {"hash":"21f8ac55838c21624ec39d88879c083e6d368764","type":"INDEX","name":"IX_BDE_PD_PROZESS_DATA_FAE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROZESS_DATA_FAE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROZESS_DATA</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FAE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}