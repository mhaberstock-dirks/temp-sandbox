create unique index dirkspzm32.ix_pers_nr_name_kurz on
    dirkspzm32.pzm_konten (
        pers_nr,
        name_kurz
    );


-- sqlcl_snapshot {"hash":"0fe1100d3a1a25314d34bd2bd3cea232083fb77c","type":"INDEX","name":"IX_PERS_NR_NAME_KURZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PERS_NR_NAME_KURZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_KONTEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NAME_KURZ</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}