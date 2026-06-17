
  CREATE INDEX "DIRKSPZM32"."IX_LVS_ARTIKEL_STATUS_IX1" ON "DIRKSPZM32"."LVS_ARTIKEL_STATUS" ("LETZTE_INVENTUR_DATUM", "ARTIKEL_ID", "ARTIKEL_STATUS_ID") 
  ;


-- sqlcl_snapshot {"hash":"c19bc7db6668fd1fa61d12297004f45e2d1e8cc3","type":"INDEX","name":"IX_LVS_ARTIKEL_STATUS_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_ARTIKEL_STATUS_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_ARTIKEL_STATUS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LETZTE_INVENTUR_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_STATUS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}