
  CREATE INDEX "IX_BDE_PD_RUECKVERF_P_ZEILE" ON "BDE_PD_RUECKVERFOLGUNG" ("SID", "FIRMA_NR", "ABFR_PARENT_ZEILE") 
  ;


-- sqlcl_snapshot {"hash":"0b8ffe6b0b6760c6aae904cf638da7a0193b559b","type":"INDEX","name":"IX_BDE_PD_RUECKVERF_P_ZEILE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_RUECKVERF_P_ZEILE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_RUECKVERFOLGUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ABFR_PARENT_ZEILE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}