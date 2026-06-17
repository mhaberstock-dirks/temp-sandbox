
  CREATE INDEX "DIRKSPZM32"."IX_BDE_FA_KOPF_SOLL_START" ON "DIRKSPZM32"."BDE_FA_KOPF" ("TERMIN_SOLL_START", "FA_NR") 
  ;


-- sqlcl_snapshot {"hash":"2006e6bf01c7b6a40bd4a4dd533602f0da063130","type":"INDEX","name":"IX_BDE_FA_KOPF_SOLL_START","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_KOPF_SOLL_START</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TERMIN_SOLL_START</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}