create index dirkspzm32.ix_s_eus_sap_send_bew_auf_id on
    dirkspzm32.s_eus_sap_send_bew (
        auf_id
    );


-- sqlcl_snapshot {"hash":"4b366c0ad7d9c2cdb6e07965d9367f82dbe55195","type":"INDEX","name":"IX_S_EUS_SAP_SEND_BEW_AUF_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_EUS_SAP_SEND_BEW_AUF_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_EUS_SAP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}