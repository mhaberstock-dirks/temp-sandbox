
  CREATE INDEX "IX_ISI_ARTIKEL_KUNDE_KUNDE_NR" ON "ISI_ARTIKEL_KUNDE" ("KUNDEN_NR") 
  ;


-- sqlcl_snapshot {"hash":"b166e736f4827ab7efc5a26b8318ae50535ea237","type":"INDEX","name":"IX_ISI_ARTIKEL_KUNDE_KUNDE_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ARTIKEL_KUNDE_KUNDE_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_KUNDE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KUNDEN_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}