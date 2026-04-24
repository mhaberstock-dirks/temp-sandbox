create index dirkspzm32.ix_s_erp_send_bew_status on
    dirkspzm32.s_erp_send_bew (
        status
    );


-- sqlcl_snapshot {"hash":"21194b17838218136dd022c7ca3a592ba3beb4b2","type":"INDEX","name":"IX_S_ERP_SEND_BEW_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ERP_SEND_BEW_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ERP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}