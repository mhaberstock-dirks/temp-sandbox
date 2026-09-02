
  CREATE INDEX "IX_MELDDATEN_KOM_STAT_BEREICH" ON "MELDUNG_DATEN" ("MD_KOMMT", "MD_STATUS", "MD_BEREICH") 
  ;


-- sqlcl_snapshot {"hash":"cbf87b70fbbd96b1eaff1faddd9cf6e42cd152ac","type":"INDEX","name":"IX_MELDDATEN_KOM_STAT_BEREICH","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MELDDATEN_KOM_STAT_BEREICH</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MELDUNG_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MD_KOMMT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MD_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MD_BEREICH</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}