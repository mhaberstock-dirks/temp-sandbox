
  CREATE INDEX "DIRKSPZM32"."IX_RES_ZUST_AKT_LEITZAHL" ON "DIRKSPZM32"."ISI_RESOURCE_ZUST_AKT" ("LEITZAHL", "FA_AG", "FA_UPOS", "RES_ID") 
  ;


-- sqlcl_snapshot {"hash":"3543a0c67335ab67422e3465d83077292618756c","type":"INDEX","name":"IX_RES_ZUST_AKT_LEITZAHL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_ZUST_AKT_LEITZAHL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RESOURCE_ZUST_AKT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}