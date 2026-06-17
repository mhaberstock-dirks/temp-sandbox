
  CREATE INDEX "DIRKSPZM32"."IX_PE_STATUS_DR_NAME_TIME" ON "DIRKSPZM32"."PE_JOBS" ("STATUS", "DRUCKER_NAME", "STATUS_TIME") 
  ;


-- sqlcl_snapshot {"hash":"ab28841a485e9718c84ec52df39c8e1776bf0827","type":"INDEX","name":"IX_PE_STATUS_DR_NAME_TIME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PE_STATUS_DR_NAME_TIME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PE_JOBS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DRUCKER_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS_TIME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}