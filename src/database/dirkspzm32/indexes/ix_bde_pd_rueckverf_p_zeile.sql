create index dirkspzm32.ix_bde_pd_rueckverf_p_zeile on
    dirkspzm32.bde_pd_rueckverfolgung (
        sid,
        firma_nr,
        abfr_parent_zeile
    );


-- sqlcl_snapshot {"hash":"359cec5baf206f90846ee9241ed8aefa61cd9511","type":"INDEX","name":"IX_BDE_PD_RUECKVERF_P_ZEILE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_RUECKVERF_P_ZEILE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_RUECKVERFOLGUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ABFR_PARENT_ZEILE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}