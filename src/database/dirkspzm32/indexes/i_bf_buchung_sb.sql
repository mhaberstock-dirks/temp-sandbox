
  CREATE INDEX "I_BF_BUCHUNG_SB" ON "S_HUF_SEND_BEW" ("STATUS", "BEWEGUNGSART") 
  ;


-- sqlcl_snapshot {"hash":"c77bf2b4ba8c8bf1147b115e29dea0aec29ccde9","type":"INDEX","name":"I_BF_BUCHUNG_SB","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>I_BF_BUCHUNG_SB</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_HUF_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEWEGUNGSART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}