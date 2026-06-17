
  CREATE INDEX "DIRKSPZM32"."IX_LAM_BH_FI_HIST_BUCH_DAT" ON "DIRKSPZM32"."LVS_LAM_BH_HIST" ("SID", "FIRMA_NR", "BUCH_DATUM") 
  ;


-- sqlcl_snapshot {"hash":"0beccfe28a142b16c9657265ab10282700cbc524","type":"INDEX","name":"IX_LAM_BH_FI_HIST_BUCH_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_FI_HIST_BUCH_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BUCH_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}