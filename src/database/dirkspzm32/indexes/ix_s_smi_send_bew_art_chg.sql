
  CREATE INDEX "DIRKSPZM32"."IX_S_SMI_SEND_BEW_ART_CHG" ON "DIRKSPZM32"."S_SMI_SEND_BEW" ("ARTIKEL", "CHARGE", "AKTION") 
  ;


-- sqlcl_snapshot {"hash":"42586a13d9ae9120383650f06c3ae0bb51ad928f","type":"INDEX","name":"IX_S_SMI_SEND_BEW_ART_CHG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_SMI_SEND_BEW_ART_CHG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SMI_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHARGE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AKTION</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}