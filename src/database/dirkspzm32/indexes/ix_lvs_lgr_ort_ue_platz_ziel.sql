
  CREATE UNIQUE INDEX "DIRKSPZM32"."IX_LVS_LGR_ORT_UE_PLATZ_ZIEL" ON "DIRKSPZM32"."LVS_LGR_ORT_UE_PLATZ" ("LGR_ORT_ZIEL", "LGR_ORT_QUELLE") 
  ;


-- sqlcl_snapshot {"hash":"0986e1c08ab6d057db4c258c8ab4656bba312790","type":"INDEX","name":"IX_LVS_LGR_ORT_UE_PLATZ_ZIEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_ORT_UE_PLATZ_ZIEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR_ORT_UE_PLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_ZIEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_QUELLE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}