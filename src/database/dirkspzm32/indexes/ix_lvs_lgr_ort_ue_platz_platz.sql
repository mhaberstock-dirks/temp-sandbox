
  CREATE INDEX "IX_LVS_LGR_ORT_UE_PLATZ_PLATZ" ON "LVS_LGR_ORT_UE_PLATZ" ("LGR_PLATZ", "LGR_ORT_QUELLE") 
  ;


-- sqlcl_snapshot {"hash":"e1fb67fc6857e09621ff9163d4a2ebf4a96c9064","type":"INDEX","name":"IX_LVS_LGR_ORT_UE_PLATZ_PLATZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_ORT_UE_PLATZ_PLATZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR_ORT_UE_PLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_QUELLE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}