
  CREATE INDEX "DIRKSPZM32"."IX_LAM_BH_HIST_ARTIKEL_CHARGE" ON "DIRKSPZM32"."LVS_LAM_BH_HIST" ("ARTIKEL_ID", "CHARGE_ID") 
  ;


-- sqlcl_snapshot {"hash":"c50f406b86b73e008716896ed3d51122c0d67a98","type":"INDEX","name":"IX_LAM_BH_HIST_ARTIKEL_CHARGE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_ARTIKEL_CHARGE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHARGE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}