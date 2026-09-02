
  CREATE INDEX "IX_S_ERP_SEND_BEW_TAB_LEIT" ON "S_ERP_SEND_BEW" ("TABELLE", "LEITZAHL") 
  ;


-- sqlcl_snapshot {"hash":"467911413ddf3204793ea407d3141c4519a77580","type":"INDEX","name":"IX_S_ERP_SEND_BEW_TAB_LEIT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ERP_SEND_BEW_TAB_LEIT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ERP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TABELLE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}