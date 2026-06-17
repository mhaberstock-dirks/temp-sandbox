
  CREATE INDEX "DIRKSPZM32"."IX_ZE_TS_SA_KURZ_DATUM" ON "DIRKSPZM32"."PZM_ZE_TAGESSATZ" ("TS_SA_KURZNAME", "TS_DATUM") 
  ;


-- sqlcl_snapshot {"hash":"fa90326cb2123a9b12d13149b3971de90df02b9d","type":"INDEX","name":"IX_ZE_TS_SA_KURZ_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_TS_SA_KURZ_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_TAGESSATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TS_SA_KURZNAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}