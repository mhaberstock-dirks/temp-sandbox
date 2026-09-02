
  CREATE INDEX "IX_ISI_LIEFS_AVIS_STAT" ON "ISI_LIEFS" ("AVIS_STATUS", "LI_NR") 
  ;


-- sqlcl_snapshot {"hash":"21ec3dba788934f08c80064623e0ad356e4fc49a","type":"INDEX","name":"IX_ISI_LIEFS_AVIS_STAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_LIEFS_AVIS_STAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_LIEFS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AVIS_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LI_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}