
  CREATE INDEX "DIRKSPZM32"."IX_BDE_FA_AG_FREIGABE_STATUS" ON "DIRKSPZM32"."BDE_FA_AUFTRAG" ("FREIG_STATUS", "FIRMA_NR", "SID") 
  ;


-- sqlcl_snapshot {"hash":"1629c075e37344d73e323d00204053536aef206e","type":"INDEX","name":"IX_BDE_FA_AG_FREIGABE_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AG_FREIGABE_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FREIG_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}