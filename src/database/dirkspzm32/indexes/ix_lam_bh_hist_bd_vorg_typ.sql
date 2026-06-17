
  CREATE INDEX "DIRKSPZM32"."IX_LAM_BH_HIST_BD_VORG_TYP" ON "DIRKSPZM32"."LVS_LAM_BH_HIST" ("BUCH_DATUM", "VORG_TYP", "BUS", "MENGE") 
  ;


-- sqlcl_snapshot {"hash":"f3736c7717ab15c3db13769e702b31e1ed6327ad","type":"INDEX","name":"IX_LAM_BH_HIST_BD_VORG_TYP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_BD_VORG_TYP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>BUCH_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MENGE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}