create index dirkspzm32.ix_lvs_lam_owner on
    dirkspzm32.lvs_lam (
        owner_address_id
    );


-- sqlcl_snapshot {"hash":"1994161c5bee3b0bcb4aa70e29258fde8e282916","type":"INDEX","name":"IX_LVS_LAM_OWNER","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LAM_OWNER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>OWNER_ADDRESS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}