create index dirkspzm32.ix_acs_user_access_log_3 on
    dirkspzm32.acs_user_access_log (
        access_point_device_info
    );


-- sqlcl_snapshot {"hash":"3f063d015a94f09993964df197dbf5fbacd4e6a4","type":"INDEX","name":"IX_ACS_USER_ACCESS_LOG_3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ACS_USER_ACCESS_LOG_3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ACS_USER_ACCESS_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_POINT_DEVICE_INFO</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}