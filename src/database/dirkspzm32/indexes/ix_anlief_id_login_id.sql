create index dirkspzm32.ix_anlief_id_login_id on
    dirkspzm32.lvs_anlief_id_liste (
        login_id,
        anlief_id
    );


-- sqlcl_snapshot {"hash":"cee494ce0265c43f22951d43d1e6b37ea663404e","type":"INDEX","name":"IX_ANLIEF_ID_LOGIN_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ANLIEF_ID_LOGIN_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_ANLIEF_ID_LISTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOGIN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ANLIEF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}