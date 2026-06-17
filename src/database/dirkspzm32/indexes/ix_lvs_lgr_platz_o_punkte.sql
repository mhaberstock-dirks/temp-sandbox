
  CREATE INDEX "DIRKSPZM32"."IX_LVS_LGR_PLATZ_O_PUNKTE" ON "DIRKSPZM32"."LVS_LGR" (REPLACE("LGR_PLATZ",'.')) 
  ;


-- sqlcl_snapshot {"hash":"a2a784432bb7e3e5e2ecf254a828d8ed2fc14ca4","type":"INDEX","name":"IX_LVS_LGR_PLATZ_O_PUNKTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_PLATZ_O_PUNKTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REPLACE(\"LGR_PLATZ\",'.')</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}