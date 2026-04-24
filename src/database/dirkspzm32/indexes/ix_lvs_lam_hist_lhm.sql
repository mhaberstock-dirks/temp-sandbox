create index dirkspzm32.ix_lvs_lam_hist_lhm on
    dirkspzm32.lvs_lam_hist (
        lhm_id
    );


-- sqlcl_snapshot {"hash":"86828a130e8c9553dda0bd9ab45242f563278538","type":"INDEX","name":"IX_LVS_LAM_HIST_LHM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LAM_HIST_LHM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}