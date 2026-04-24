create index dirkspzm32.ix_isi_scan_log_status_lte_id on
    dirkspzm32.isi_scan_log (
        scan_ok,
        lte_id
    );


-- sqlcl_snapshot {"hash":"de5649521f094b435af877e97f4d29d1e4e2159a","type":"INDEX","name":"IX_ISI_SCAN_LOG_STATUS_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_SCAN_LOG_STATUS_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_SCAN_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SCAN_OK</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}