
  CREATE INDEX "DIRKSPZM32"."IX_ARTIKEL_CTRL_ZEICHN" ON "DIRKSPZM32"."ISI_ARTIKEL_CTRL" ("ARTIKEL_ID", "ZEICHNUNG", "ZEICHNUNG_INDEX") 
  ;


-- sqlcl_snapshot {"hash":"24ec5095db359e34a3a489350244ac373c363f33","type":"INDEX","name":"IX_ARTIKEL_CTRL_ZEICHN","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ARTIKEL_CTRL_ZEICHN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_CTRL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZEICHNUNG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZEICHNUNG_INDEX</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}