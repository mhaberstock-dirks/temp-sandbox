create index dirkspzm32.ix_isi_db_aktivitaet_q_rowid on
    dirkspzm32.isi_db_aktivitaet (
        quell_row_id
    );


-- sqlcl_snapshot {"hash":"a282584d57a6c661765c7e45db2eaee3c9ce05fd","type":"INDEX","name":"IX_ISI_DB_AKTIVITAET_Q_ROWID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_DB_AKTIVITAET_Q_ROWID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_DB_AKTIVITAET</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>QUELL_ROW_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}