create index dirkspzm32.ix_acs_user_access_log_2 on
    dirkspzm32.acs_user_access_log (
        user_id
    );


-- sqlcl_snapshot {"hash":"1116e6608624507a795d2941f16fed2b34af3c2e","type":"INDEX","name":"IX_ACS_USER_ACCESS_LOG_2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ACS_USER_ACCESS_LOG_2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ACS_USER_ACCESS_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>USER_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}