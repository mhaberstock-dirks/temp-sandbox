
  CREATE INDEX "DIRKSPZM32"."IX_LAM_HIST_ART_ID_MHD" ON "DIRKSPZM32"."LVS_LAM_HIST" ("SID", "ARTIKEL_ID", "LAM_MHD") 
  ;


-- sqlcl_snapshot {"hash":"da9c3acd1b28dce2f86e3d343d840496ba34ea61","type":"INDEX","name":"IX_LAM_HIST_ART_ID_MHD","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_HIST_ART_ID_MHD</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_MHD</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}