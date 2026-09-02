
  CREATE UNIQUE INDEX "IX_S_EUS_SAP_SEND_BEW_DATE" ON "S_EUS_SAP_SEND_BEW" ("B_DATE", "TS") 
  ;


-- sqlcl_snapshot {"hash":"c901b64b6a3756e0957b7a7b14cb07aa7c8ac419","type":"INDEX","name":"IX_S_EUS_SAP_SEND_BEW_DATE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_EUS_SAP_SEND_BEW_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_EUS_SAP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>B_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}