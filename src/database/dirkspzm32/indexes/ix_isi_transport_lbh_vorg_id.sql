
  CREATE INDEX "IX_ISI_TRANSPORT_LBH_VORG_ID" ON "ISI_TRANSPORT_HIST" ("LAM_BH_VORGANG_ID", "TS") 
  ;


-- sqlcl_snapshot {"hash":"6ff70116d7c5c911d76858a16be4cc31cd08f86e","type":"INDEX","name":"IX_ISI_TRANSPORT_LBH_VORG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_LBH_VORG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LAM_BH_VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}