
  CREATE INDEX "IX_ZE_TS_SA_KURZ_DATUM" ON "PZM_ZE_TAGESSATZ" ("TS_SA_KURZNAME", "TS_DATUM") 
  ;


-- sqlcl_snapshot {"hash":"baec789672476d73a48a3a334cf131114737d35d","type":"INDEX","name":"IX_ZE_TS_SA_KURZ_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_TS_SA_KURZ_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_TAGESSATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TS_SA_KURZNAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}