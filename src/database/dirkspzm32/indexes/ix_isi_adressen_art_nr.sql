
  CREATE INDEX "IX_ISI_ADRESSEN_ART_NR" ON "ISI_ADRESSEN" ("ADR_ART", "ADR_NR") 
  ;


-- sqlcl_snapshot {"hash":"9cb1d4335d5ecf4b856f22e8fbad7724c20c1992","type":"INDEX","name":"IX_ISI_ADRESSEN_ART_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ADRESSEN_ART_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ADRESSEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ADR_ART</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ADR_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}