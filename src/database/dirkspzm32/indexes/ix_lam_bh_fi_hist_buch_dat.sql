
  CREATE INDEX "IX_LAM_BH_FI_HIST_BUCH_DAT" ON "LVS_LAM_BH_HIST" ("SID", "FIRMA_NR", "BUCH_DATUM") 
  ;


-- sqlcl_snapshot {"hash":"f84e4fc6e9784be4f896bc3140b2c9b07147b342","type":"INDEX","name":"IX_LAM_BH_FI_HIST_BUCH_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_FI_HIST_BUCH_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BUCH_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}