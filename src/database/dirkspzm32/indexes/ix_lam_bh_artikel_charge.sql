
  CREATE INDEX "IX_LAM_BH_ARTIKEL_CHARGE" ON "LVS_LAM_BH" ("ARTIKEL_ID", "CHARGE_ID") 
  ;


-- sqlcl_snapshot {"hash":"dce9e525bb02cf45cdd1ad3f4eb1d3c0f939382f","type":"INDEX","name":"IX_LAM_BH_ARTIKEL_CHARGE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_ARTIKEL_CHARGE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHARGE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}