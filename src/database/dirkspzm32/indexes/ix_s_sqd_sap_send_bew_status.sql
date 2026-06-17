
  CREATE INDEX "DIRKSPZM32"."IX_S_SQD_SAP_SEND_BEW_STATUS" ON "DIRKSPZM32"."S_SQD_SAP_SEND_BEW" ("STATUS", "LEITZAHL", "FA_AG", "FA_UPOS") 
  ;


-- sqlcl_snapshot {"hash":"605cb16352409a007c89fe18185fe622494aaf67","type":"INDEX","name":"IX_S_SQD_SAP_SEND_BEW_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_SQD_SAP_SEND_BEW_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SQD_SAP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}