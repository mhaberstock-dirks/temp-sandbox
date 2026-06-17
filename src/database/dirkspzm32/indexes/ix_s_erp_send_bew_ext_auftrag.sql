
  CREATE INDEX "DIRKSPZM32"."IX_S_ERP_SEND_BEW_EXT_AUFTRAG" ON "DIRKSPZM32"."S_ERP_SEND_BEW" ("EXT_AUFTRAG", "FEHLER_CODE") 
  ;


-- sqlcl_snapshot {"hash":"363e8e2610f8cae1feb6db10d0a5bd89c05a4956","type":"INDEX","name":"IX_S_ERP_SEND_BEW_EXT_AUFTRAG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ERP_SEND_BEW_EXT_AUFTRAG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ERP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EXT_AUFTRAG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FEHLER_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}