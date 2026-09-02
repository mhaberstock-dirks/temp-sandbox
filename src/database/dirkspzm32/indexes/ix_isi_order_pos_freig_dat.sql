
  CREATE INDEX "IX_ISI_ORDER_POS_FREIG_DAT" ON "ISI_ORDER_POS" ("FREIGABE_DATUM", "AUF_ID") 
  ;


-- sqlcl_snapshot {"hash":"97494a58e1e25350ff2f2382c08d0bf0f9be7f73","type":"INDEX","name":"IX_ISI_ORDER_POS_FREIG_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_FREIG_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FREIGABE_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}