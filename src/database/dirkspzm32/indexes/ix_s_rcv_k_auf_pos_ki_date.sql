
  CREATE INDEX "DIRKSPZM32"."IX_S_RCV_K_AUF_POS_KI_DATE" ON "DIRKSPZM32"."S_RCV_KUNDEN_AUFTR_POS" ("KOM_INFO", "ORDER_DATUM") 
  ;


-- sqlcl_snapshot {"hash":"201b3bc9c00b4f988cce5f4e706744fc743bf3d9","type":"INDEX","name":"IX_S_RCV_K_AUF_POS_KI_DATE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RCV_K_AUF_POS_KI_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_KUNDEN_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOM_INFO</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}