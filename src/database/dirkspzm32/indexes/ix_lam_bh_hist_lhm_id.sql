create index dirkspzm32.ix_lam_bh_hist_lhm_id on
    dirkspzm32.lvs_lam_bh_hist (
        lhm_id
    );


-- sqlcl_snapshot {"hash":"4ac493442ac5a5e3326ab93c7ec0d0959fac1409","type":"INDEX","name":"IX_LAM_BH_HIST_LHM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_LHM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}