create unique index dirkspzm32.ix_lvs_lhm_hist_te on
    dirkspzm32.lvs_lhm_hist (
        lte_id,
        lhm_id
    );


-- sqlcl_snapshot {"hash":"e1bb3dca48d0522826589bb69daa3b8fa9ffeca5","type":"INDEX","name":"IX_LVS_LHM_HIST_TE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LHM_HIST_TE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LHM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}