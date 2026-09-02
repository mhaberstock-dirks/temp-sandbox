
  CREATE INDEX "IX_ISI_ORDER_POS_VORG_ARTIKEL" ON "ISI_ORDER_POS" ("VORGANG_ID", "ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"43db46e2c3d7783a6ffea1cf3b0a4a40dddf3eee","type":"INDEX","name":"IX_ISI_ORDER_POS_VORG_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_VORG_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}