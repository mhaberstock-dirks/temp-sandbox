
  CREATE UNIQUE INDEX "DIRKSPZM32"."IX_S_ERP_SEND_BEW_DATE" ON "DIRKSPZM32"."S_ERP_SEND_BEW" ("B_DATE", "BEW_ID") 
  ;


-- sqlcl_snapshot {"hash":"b4ac78cf55853491d12059f561b8f2afbb9ffc6b","type":"INDEX","name":"IX_S_ERP_SEND_BEW_DATE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ERP_SEND_BEW_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ERP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>B_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEW_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}