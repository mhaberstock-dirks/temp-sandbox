
  CREATE INDEX "DIRKSPZM32"."IX_ISI_ORDER_POS_AUFNR_POS" ON "DIRKSPZM32"."ISI_ORDER_POS" ("AUFTRAG", "POS_NR", "UPOS_NR") 
  ;


-- sqlcl_snapshot {"hash":"cfeec6d514b5de81c80412a4e39761f14b0eb81e","type":"INDEX","name":"IX_ISI_ORDER_POS_AUFNR_POS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_AUFNR_POS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUFTRAG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPOS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}