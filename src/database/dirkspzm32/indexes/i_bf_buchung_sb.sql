
  CREATE INDEX "DIRKSPZM32"."I_BF_BUCHUNG_SB" ON "DIRKSPZM32"."S_HUF_SEND_BEW" ("STATUS", "BEWEGUNGSART") 
  ;


-- sqlcl_snapshot {"hash":"524578583504209cf512c1b31943df2f2e5d8c46","type":"INDEX","name":"I_BF_BUCHUNG_SB","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>I_BF_BUCHUNG_SB</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_HUF_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEWEGUNGSART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}