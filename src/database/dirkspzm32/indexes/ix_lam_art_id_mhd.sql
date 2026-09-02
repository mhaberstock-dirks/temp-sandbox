
  CREATE INDEX "IX_LAM_ART_ID_MHD" ON "LVS_LAM" ("ARTIKEL_ID", "LAM_MHD") 
  ;


-- sqlcl_snapshot {"hash":"8463b39486b5e660edaa118a3ebe97a61c17eb2b","type":"INDEX","name":"IX_LAM_ART_ID_MHD","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_ART_ID_MHD</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_MHD</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}