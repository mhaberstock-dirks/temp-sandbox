
  CREATE INDEX "IX_ISI_ORDER_KOPF_FERTIG_DATUM" ON "ISI_ORDER_KOPF" ("FERTIG_DATUM", "VORGANG_TYP", "VORGANG_ID") 
  ;


-- sqlcl_snapshot {"hash":"6dc2d75d027ef9e8755002d152b597531a0212ad","type":"INDEX","name":"IX_ISI_ORDER_KOPF_FERTIG_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_KOPF_FERTIG_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FERTIG_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}