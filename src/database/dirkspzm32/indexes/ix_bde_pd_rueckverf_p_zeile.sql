
  CREATE INDEX "DIRKSPZM32"."IX_BDE_PD_RUECKVERF_P_ZEILE" ON "DIRKSPZM32"."BDE_PD_RUECKVERFOLGUNG" ("SID", "FIRMA_NR", "ABFR_PARENT_ZEILE") 
  ;


-- sqlcl_snapshot {"hash":"8429375e11d53d2698bf681ed1541386d83f81b6","type":"INDEX","name":"IX_BDE_PD_RUECKVERF_P_ZEILE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_RUECKVERF_P_ZEILE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_RUECKVERFOLGUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ABFR_PARENT_ZEILE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}