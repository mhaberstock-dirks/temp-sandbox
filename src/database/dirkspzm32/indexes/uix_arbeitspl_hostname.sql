
  CREATE UNIQUE INDEX "UIX_ARBEITSPL_HOSTNAME" ON "ISI_ARBEITSPLATZ" (LOWER("IP_NAME")) 
  ;


-- sqlcl_snapshot {"hash":"38c0b73c33600fa7af25ac8a3e8c98e520fcaf9c","type":"INDEX","name":"UIX_ARBEITSPL_HOSTNAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UIX_ARBEITSPL_HOSTNAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARBEITSPLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>LOWER(\"IP_NAME\")</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}