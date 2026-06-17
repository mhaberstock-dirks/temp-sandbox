
  CREATE INDEX "DIRKSPZM32"."IX_ISI_ORDER_POS_VORG_ARTIKEL" ON "DIRKSPZM32"."ISI_ORDER_POS" ("VORGANG_ID", "ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"66d549591b383649721258d1a5e9cecc05aedf51","type":"INDEX","name":"IX_ISI_ORDER_POS_VORG_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_VORG_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}