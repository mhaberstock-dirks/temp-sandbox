
  CREATE INDEX "IX_PZM_VORGANGSQUAL_W_PLAN_DATUM" ON "PZM_VORGANGSQUAL_W_PLAN" ("W_PLAN_DATUM", "W_PLAN_PERS_NR") 
  ;


-- sqlcl_snapshot {"hash":"fc836f982d87c95198a24f833116c2c8f891a89e","type":"INDEX","name":"IX_PZM_VORGANGSQUAL_W_PLAN_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PZM_VORGANGSQUAL_W_PLAN_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_VORGANGSQUAL_W_PLAN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>W_PLAN_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>W_PLAN_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}