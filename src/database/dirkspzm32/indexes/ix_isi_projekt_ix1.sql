create index dirkspzm32.ix_isi_projekt_ix1 on
    dirkspzm32.isi_project (
        manager_login_id
    );


-- sqlcl_snapshot {"hash":"b985cacbfef70f1d663a9f8c5954dfa9fdb38fee","type":"INDEX","name":"IX_ISI_PROJEKT_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_PROJEKT_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_PROJECT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MANAGER_LOGIN_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}