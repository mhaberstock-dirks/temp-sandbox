
  CREATE INDEX "DIRKSPZM32"."IX_ARTIKEL_CTRL_FUNKTION" ON "DIRKSPZM32"."ISI_ARTIKEL_CTRL" ("FUNKTION", "ARTIKEL_ID") 
  ;


-- sqlcl_snapshot {"hash":"8fae7602e467a62720b47e289d7b92af17b9bd45","type":"INDEX","name":"IX_ARTIKEL_CTRL_FUNKTION","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ARTIKEL_CTRL_FUNKTION</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_CTRL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FUNKTION</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}