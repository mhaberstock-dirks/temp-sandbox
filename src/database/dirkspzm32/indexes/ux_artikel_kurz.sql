
  CREATE UNIQUE INDEX "UX_ARTIKEL_KURZ" ON "S_RCV_ARTIKEL" ("ARTIKEL_KURZ") 
  ;


-- sqlcl_snapshot {"hash":"bab205e92a5bbcfbdf872635d060cd2b23318ae6","type":"INDEX","name":"UX_ARTIKEL_KURZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UX_ARTIKEL_KURZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_ARTIKEL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_KURZ</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}