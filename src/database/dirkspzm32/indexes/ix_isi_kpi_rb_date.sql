
  CREATE INDEX "DIRKSPZM32"."IX_ISI_KPI_RB_DATE" ON "DIRKSPZM32"."ISI_KPI_RING_BUFFER" ("WERT_DATUM", "KPI_NAME", "KPI_SEL_PARAM") 
  ;


-- sqlcl_snapshot {"hash":"5988007b6a3265b094dd599742423faeace891c8","type":"INDEX","name":"IX_ISI_KPI_RB_DATE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_KPI_RB_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KPI_RING_BUFFER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>WERT_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KPI_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KPI_SEL_PARAM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}