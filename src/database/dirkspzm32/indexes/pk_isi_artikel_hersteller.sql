
  CREATE UNIQUE INDEX "DIRKSPZM32"."PK_ISI_ARTIKEL_HERSTELLER" ON "DIRKSPZM32"."ISI_ARTIKEL_HERSTELLER" ("ARTIKEL_ID", "HERSTELLERKUERZEL", "SID") 
  ;


-- sqlcl_snapshot {"hash":"c3aae16b3769ed4a3a4f3697b6820bd451639f20","type":"INDEX","name":"PK_ISI_ARTIKEL_HERSTELLER","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PK_ISI_ARTIKEL_HERSTELLER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_HERSTELLER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HERSTELLERKUERZEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}