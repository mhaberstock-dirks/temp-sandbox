
  CREATE INDEX "DIRKSPZM32"."IX_LVS_LGR_VERWEND" ON "DIRKSPZM32"."LVS_LGR" ("LGR_VERWENDUNG", "LGR_PLATZ", "SID", "FIRMA_NR") 
  ;


-- sqlcl_snapshot {"hash":"e084d9501ad357d9de73cfda9b9bd7dadd772a61","type":"INDEX","name":"IX_LVS_LGR_VERWEND","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_VERWEND</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_VERWENDUNG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}