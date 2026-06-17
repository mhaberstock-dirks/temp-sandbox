
  CREATE INDEX "DIRKSPZM32"."IX_ARTIKEL_BUCH_DAT" ON "DIRKSPZM32"."LVS_LAM_BH" ("ARTIKEL_ID", "BUCH_DATUM") 
  ;


-- sqlcl_snapshot {"hash":"9966a6281e87b205121a2313d57a0218816a7bf3","type":"INDEX","name":"IX_ARTIKEL_BUCH_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ARTIKEL_BUCH_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BUCH_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}