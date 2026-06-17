
  CREATE INDEX "DIRKSPZM32"."IX_MELDDATUM_STATUS" ON "DIRKSPZM32"."MELDUNG_DATEN" ("MD_STATUS", "MD_BEREICH") 
  ;


-- sqlcl_snapshot {"hash":"1ca7b46d45bde465e509002c68309a2f6e54f522","type":"INDEX","name":"IX_MELDDATUM_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MELDDATUM_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MELDUNG_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MD_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MD_BEREICH</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}