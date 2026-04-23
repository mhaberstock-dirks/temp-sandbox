create index dirkspzm32.ix_zeaw_pers_nr on
    dirkspzm32.pzm_ze_loa_ausw (
        zeaw_pers_nr
    );


-- sqlcl_snapshot {"hash":"590c542340efca5b072ec14a8127228a9e2b2532","type":"INDEX","name":"IX_ZEAW_PERS_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZEAW_PERS_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_LOA_AUSW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZEAW_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}