
  CREATE INDEX "IX_KOMM_TNK_ID" ON "ISI_KOMM_ORDER" ("TRANSP_ID_NACH_KOMM") 
  ;


-- sqlcl_snapshot {"hash":"f92f92deafbc46229715328d01068e39d4f8e9bb","type":"INDEX","name":"IX_KOMM_TNK_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_TNK_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TRANSP_ID_NACH_KOMM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}