
  CREATE UNIQUE INDEX "UX_EDI_VDA4987_PACK" ON "EDI_VDA4987_PACK" ("PACK_ITEM_ID", "POS") 
  ;


-- sqlcl_snapshot {"hash":"3859c6565ecc896fdbbb219f4fa597eedc7e9628","type":"INDEX","name":"UX_EDI_VDA4987_PACK","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UX_EDI_VDA4987_PACK</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>EDI_VDA4987_PACK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PACK_ITEM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}