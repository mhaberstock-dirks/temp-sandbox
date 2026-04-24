create index dirkspzm32.ix_lhm_komm_q_lte_id on
    dirkspzm32.lvs_lhm (
        komm_quell_lte_id,
        lhm_id
    );


-- sqlcl_snapshot {"hash":"fa2d61a159a54f5911d29f98b0f05c551d089045","type":"INDEX","name":"IX_LHM_KOMM_Q_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LHM_KOMM_Q_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LHM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_QUELL_LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}