
  CREATE INDEX "IX_LVS_LGR_PLATZ_O_PUNKTE" ON "LVS_LGR" (REPLACE("LGR_PLATZ",'.')) 
  ;


-- sqlcl_snapshot {"hash":"2dacfa039429e2fd7394464ec9bdd0195bb39ac6","type":"INDEX","name":"IX_LVS_LGR_PLATZ_O_PUNKTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_PLATZ_O_PUNKTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>REPLACE(\"LGR_PLATZ\",'.')</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}