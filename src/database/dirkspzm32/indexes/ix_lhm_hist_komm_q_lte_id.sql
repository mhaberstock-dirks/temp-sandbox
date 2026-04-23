create index dirkspzm32.ix_lhm_hist_komm_q_lte_id on
    dirkspzm32.lvs_lhm_hist (
        komm_quell_lte_id,
        lhm_id
    );


-- sqlcl_snapshot {"hash":"735d9d43456eea9e02e3cd54d86ea9d122f87899","type":"INDEX","name":"IX_LHM_HIST_KOMM_Q_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LHM_HIST_KOMM_Q_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LHM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_QUELL_LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}