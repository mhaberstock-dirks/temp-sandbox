create index dirkspzm32.ix_isi_lief_datum on
    dirkspzm32.isi_liefs (
        liefs_datum
    );


-- sqlcl_snapshot {"hash":"dbdef613515665d5087cf757161d9edad56c3522","type":"INDEX","name":"IX_ISI_LIEF_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_LIEF_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_LIEFS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LIEFS_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}