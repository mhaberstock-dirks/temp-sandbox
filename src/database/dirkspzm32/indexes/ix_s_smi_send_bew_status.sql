create index dirkspzm32.ix_s_smi_send_bew_status on
    dirkspzm32.s_smi_send_bew (
        status
    );


-- sqlcl_snapshot {"hash":"c0aee934e7c0d296a38b0c9dd656f9a2c9dfbe4d","type":"INDEX","name":"IX_S_SMI_SEND_BEW_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_SMI_SEND_BEW_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SMI_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}