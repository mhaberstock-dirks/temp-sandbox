
  CREATE INDEX "DIRKSPZM32"."IX_BDE_LEAD_LEITZAHL" ON "DIRKSPZM32"."BDE_FA_AUFTRAG" ("LEAD_LEITZAHL", "KENZ_LETZT_AG", "AG_ID") 
  ;


-- sqlcl_snapshot {"hash":"9de5598e6f60c5e3826d0527dba521cb2f90fd91","type":"INDEX","name":"IX_BDE_LEAD_LEITZAHL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_LEAD_LEITZAHL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEAD_LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KENZ_LETZT_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}