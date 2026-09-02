
  CREATE INDEX "IX_BDE_PD_PROZESS_DATA_RES" ON "BDE_PD_PROZESS_DATA" ("RES_ID", "RES_PROZESS_DATA_DATE") 
  ;


-- sqlcl_snapshot {"hash":"af534b17675271d1045abe14db774fd0f69affc9","type":"INDEX","name":"IX_BDE_PD_PROZESS_DATA_RES","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROZESS_DATA_RES</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROZESS_DATA</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_PROZESS_DATA_DATE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}