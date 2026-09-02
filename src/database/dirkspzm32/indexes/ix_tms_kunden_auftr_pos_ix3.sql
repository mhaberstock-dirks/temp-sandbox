
  CREATE INDEX "IX_TMS_KUNDEN_AUFTR_POS_IX3" ON "TMS_KUNDEN_AUFTR_POS" ("ERZ_DATUM", "STATUS", "KUNDEN_AUFTR_POS_ID") 
  ;


-- sqlcl_snapshot {"hash":"4ca8892c57125ede8359e3dc34c239172cc352cf","type":"INDEX","name":"IX_TMS_KUNDEN_AUFTR_POS_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_TMS_KUNDEN_AUFTR_POS_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>TMS_KUNDEN_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERZ_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KUNDEN_AUFTR_POS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}