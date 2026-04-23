create index dirkspzm32.ix_acs_user_permissions_1 on
    dirkspzm32.acs_user_permissions (
        access_point_device_id
    );


-- sqlcl_snapshot {"hash":"d542fc4fe577f5cbe0046dbd9825f89da647a73a","type":"INDEX","name":"IX_ACS_USER_PERMISSIONS_1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ACS_USER_PERMISSIONS_1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ACS_USER_PERMISSIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ACCESS_POINT_DEVICE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}