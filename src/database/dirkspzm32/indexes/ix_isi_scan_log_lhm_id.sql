create index dirkspzm32.ix_isi_scan_log_lhm_id on
    dirkspzm32.isi_scan_log (
        lhm_id
    );


-- sqlcl_snapshot {"hash":"d963022fedbf2e106f017d57259bf19281a33658","type":"INDEX","name":"IX_ISI_SCAN_LOG_LHM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_SCAN_LOG_LHM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_SCAN_LOG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}