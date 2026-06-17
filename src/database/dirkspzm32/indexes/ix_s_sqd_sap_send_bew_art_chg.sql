
  CREATE INDEX "DIRKSPZM32"."IX_S_SQD_SAP_SEND_BEW_ART_CHG" ON "DIRKSPZM32"."S_SQD_SAP_SEND_BEW" ("ARTIKEL", "CHARGE", "AKTION") 
  ;


-- sqlcl_snapshot {"hash":"0d81af7013fe393b623875146156446527131b9b","type":"INDEX","name":"IX_S_SQD_SAP_SEND_BEW_ART_CHG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_SQD_SAP_SEND_BEW_ART_CHG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SQD_SAP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHARGE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AKTION</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}