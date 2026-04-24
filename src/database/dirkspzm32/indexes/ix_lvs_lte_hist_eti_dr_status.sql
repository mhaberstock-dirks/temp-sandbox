create index dirkspzm32.ix_lvs_lte_hist_eti_dr_status on
    dirkspzm32.lvs_lte_hist (
        lte_eti_druck_status,
        lte_id
    );


-- sqlcl_snapshot {"hash":"ba3b0c7bc137fb851850625ece15439ee459602b","type":"INDEX","name":"IX_LVS_LTE_HIST_ETI_DR_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_ETI_DR_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ETI_DRUCK_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}