create index dirkspzm32.ix_bde_pd_rueckverf_zeile on
    dirkspzm32.bde_pd_rueckverfolgung (
        abfr_zeile
    );


-- sqlcl_snapshot {"hash":"bfd071674e169f4295a11c85ba8bfcef70656353","type":"INDEX","name":"IX_BDE_PD_RUECKVERF_ZEILE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_RUECKVERF_ZEILE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_RUECKVERFOLGUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ABFR_ZEILE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}