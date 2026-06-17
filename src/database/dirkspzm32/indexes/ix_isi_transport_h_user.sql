
  CREATE INDEX "DIRKSPZM32"."IX_ISI_TRANSPORT_H_USER" ON "DIRKSPZM32"."ISI_TRANSPORT_HIST" ("USER_ID", "TRANSP_TYP", "TRANSP_ID") 
  ;


-- sqlcl_snapshot {"hash":"f6d65c14d9e87e45b838cf8bea151b0b8ec298c2","type":"INDEX","name":"IX_ISI_TRANSPORT_H_USER","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_H_USER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>USER_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TRANSP_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TRANSP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}