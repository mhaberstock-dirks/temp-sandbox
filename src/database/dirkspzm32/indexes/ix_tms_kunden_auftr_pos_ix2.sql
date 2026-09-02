
  CREATE INDEX "IX_TMS_KUNDEN_AUFTR_POS_IX2" ON "TMS_KUNDEN_AUFTR_POS" ("LIEFER_DATUM", "STATUS", "KUNDEN_AUFTR_POS_ID") 
  ;


-- sqlcl_snapshot {"hash":"431ee62eeb77475ccf2a5df3e7f0eb59acb6b4ad","type":"INDEX","name":"IX_TMS_KUNDEN_AUFTR_POS_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_TMS_KUNDEN_AUFTR_POS_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>TMS_KUNDEN_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LIEFER_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KUNDEN_AUFTR_POS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}