
  CREATE INDEX "DIRKSPZM32"."IX_RES_TYP_LINIE" ON "DIRKSPZM32"."ISI_RESOURCE" ("LINIE_RES_ID", "TYP", "RES_ID") 
  ;


-- sqlcl_snapshot {"hash":"1bd1954d7b8e4b11ae9eea308100e022ec6478fb","type":"INDEX","name":"IX_RES_TYP_LINIE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_TYP_LINIE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RESOURCE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LINIE_RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}