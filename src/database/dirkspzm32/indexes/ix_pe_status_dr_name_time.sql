create index dirkspzm32.ix_pe_status_dr_name_time on
    dirkspzm32.pe_jobs (
        status,
        drucker_name,
        status_time
    );


-- sqlcl_snapshot {"hash":"e4c22d7a39cd3ee65e73c0996f81c0fd755a782a","type":"INDEX","name":"IX_PE_STATUS_DR_NAME_TIME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PE_STATUS_DR_NAME_TIME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PE_JOBS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DRUCKER_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS_TIME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}