
  CREATE INDEX "DIRKSPZM32"."IX_LVS_INV_JOB_KOPF_ART_FA_AG" ON "DIRKSPZM32"."LVS_INVENTUR_JOB_KOPF" ("ARTIKEL_ID", "FA_AG", "ERSTELLT_DATUM") 
  ;


-- sqlcl_snapshot {"hash":"a7be90a37771a47286b2dd39deedd05c8c81bb70","type":"INDEX","name":"IX_LVS_INV_JOB_KOPF_ART_FA_AG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_INV_JOB_KOPF_ART_FA_AG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_INVENTUR_JOB_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERSTELLT_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}