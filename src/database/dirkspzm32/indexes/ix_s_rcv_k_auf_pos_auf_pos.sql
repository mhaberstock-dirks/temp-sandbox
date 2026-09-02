
  CREATE INDEX "IX_S_RCV_K_AUF_POS_AUF_POS" ON "S_RCV_KUNDEN_AUFTR_POS" ("AUFTRAG", "POS_NR") 
  ;


-- sqlcl_snapshot {"hash":"3a02553da16f49850c71dcb5bcd06b0cb5e21b4e","type":"INDEX","name":"IX_S_RCV_K_AUF_POS_AUF_POS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RCV_K_AUF_POS_AUF_POS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_KUNDEN_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUFTRAG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}