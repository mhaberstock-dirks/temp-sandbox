
  CREATE INDEX "IX_LVS_INV_JOB_KOPF_STATUS" ON "LVS_INVENTUR_JOB_KOPF" ("INV_STATUS", "ERSTELLT_DATUM", "INVENTUR_ID") 
  ;


-- sqlcl_snapshot {"hash":"a1b7fa606fdac3983f42c3fc9f437baf2bbf5464","type":"INDEX","name":"IX_LVS_INV_JOB_KOPF_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_INV_JOB_KOPF_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_INVENTUR_JOB_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>INV_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERSTELLT_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INVENTUR_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}