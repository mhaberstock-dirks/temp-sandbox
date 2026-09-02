
  CREATE INDEX "IX_MELDDATUM_STATUS" ON "MELDUNG_DATEN" ("MD_STATUS", "MD_BEREICH") 
  ;


-- sqlcl_snapshot {"hash":"e334face86d25b705be3892cae5a4b6077765fe4","type":"INDEX","name":"IX_MELDDATUM_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MELDDATUM_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MELDUNG_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MD_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MD_BEREICH</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}