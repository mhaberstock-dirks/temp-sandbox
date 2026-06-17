
  CREATE UNIQUE INDEX "DIRKSPZM32"."UIX_ARBEITSPL_HOSTNAME" ON "DIRKSPZM32"."ISI_ARBEITSPLATZ" (LOWER("IP_NAME")) 
  ;


-- sqlcl_snapshot {"hash":"f34e59f320fab7137e77e416252906a182ed7f2b","type":"INDEX","name":"UIX_ARBEITSPL_HOSTNAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UIX_ARBEITSPL_HOSTNAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARBEITSPLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOWER(\"IP_NAME\")</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}