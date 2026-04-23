create index dirkspzm32.ix_sec_group_mgr on
    dirkspzm32.sec_groups (
        mgr_login_id
    );


-- sqlcl_snapshot {"hash":"b7739ce7d2a7b002a86c139d75a841298b071ad0","type":"INDEX","name":"IX_SEC_GROUP_MGR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_SEC_GROUP_MGR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>SEC_GROUPS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MGR_LOGIN_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}