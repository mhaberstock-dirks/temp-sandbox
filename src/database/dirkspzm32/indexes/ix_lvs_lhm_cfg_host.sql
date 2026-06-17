
  CREATE INDEX "DIRKSPZM32"."IX_LVS_LHM_CFG_HOST" ON "DIRKSPZM32"."LVS_LHM_CFG" ("SID", "FIRMA_NR", "VERWALTET_VON", "HOST_REF_ID") 
  ;


-- sqlcl_snapshot {"hash":"86655901d12b795e6027aeb81d79e04d654d5ab5","type":"INDEX","name":"IX_LVS_LHM_CFG_HOST","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LHM_CFG_HOST</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LHM_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VERWALTET_VON</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HOST_REF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}