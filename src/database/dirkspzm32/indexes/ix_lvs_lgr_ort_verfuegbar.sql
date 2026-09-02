
  CREATE INDEX "IX_LVS_LGR_ORT_VERFUEGBAR" ON "LVS_LGR" ("LGR_ORT", "GESPERRT", "LGR_EINL_TE_VERFUEG") 
  ;


-- sqlcl_snapshot {"hash":"b812451146935fe579eca85fa0fd3170f28381a7","type":"INDEX","name":"IX_LVS_LGR_ORT_VERFUEGBAR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_ORT_VERFUEGBAR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GESPERRT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_EINL_TE_VERFUEG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}