create index dirkspzm32.ix_rep_isi_modul on
    dirkspzm32.rep_abfragen (
        mod_id,
        rep_id
    );


-- sqlcl_snapshot {"hash":"b61cb33dbbe82a15596b8b6f7e16d68420e3f8fe","type":"INDEX","name":"IX_REP_ISI_MODUL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_REP_ISI_MODUL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>REP_ABFRAGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MOD_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}