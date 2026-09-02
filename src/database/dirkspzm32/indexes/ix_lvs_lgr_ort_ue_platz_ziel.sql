
  CREATE UNIQUE INDEX "IX_LVS_LGR_ORT_UE_PLATZ_ZIEL" ON "LVS_LGR_ORT_UE_PLATZ" ("LGR_ORT_ZIEL", "LGR_ORT_QUELLE") 
  ;


-- sqlcl_snapshot {"hash":"d6b876513f9af9e3b3af38d35d75c7d66a02ac1e","type":"INDEX","name":"IX_LVS_LGR_ORT_UE_PLATZ_ZIEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_ORT_UE_PLATZ_ZIEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR_ORT_UE_PLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_ZIEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_QUELLE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}