
  CREATE INDEX "DIRKSPZM32"."IX_ISI_KPI_RB_KIP_DATUM" ON "DIRKSPZM32"."ISI_KPI_RING_BUFFER" ("KPI_NAME", "WERT_DATUM", "KPI_SEL_PARAM") 
  ;


-- sqlcl_snapshot {"hash":"5f6545b44bccaeb137be9b4702705106b93cd76c","type":"INDEX","name":"IX_ISI_KPI_RB_KIP_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_KPI_RB_KIP_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KPI_RING_BUFFER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KPI_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>WERT_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KPI_SEL_PARAM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}