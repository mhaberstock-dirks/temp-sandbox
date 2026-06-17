
  CREATE INDEX "DIRKSPZM32"."IX_ISI_TRANSPORT_PPARENT_ID" ON "DIRKSPZM32"."ISI_TRANSPORT" ("PARENT_TRANSP_ID", "FIRMA_NR", "SID") 
  ;


-- sqlcl_snapshot {"hash":"512c8d449dbd5375e380db7ec34b8b3fa5a30721","type":"INDEX","name":"IX_ISI_TRANSPORT_PPARENT_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_PPARENT_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PARENT_TRANSP_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}