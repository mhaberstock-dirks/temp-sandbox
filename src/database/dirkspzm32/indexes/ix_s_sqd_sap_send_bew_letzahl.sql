
  CREATE INDEX "IX_S_SQD_SAP_SEND_BEW_LETZAHL" ON "S_SQD_SAP_SEND_BEW" ("LEITZAHL", "FA_AG", "FA_UPOS") 
  ;


-- sqlcl_snapshot {"hash":"f317f73669ead4e18ffecc0b22bafc0df0749356","type":"INDEX","name":"IX_S_SQD_SAP_SEND_BEW_LETZAHL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_SQD_SAP_SEND_BEW_LETZAHL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SQD_SAP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}