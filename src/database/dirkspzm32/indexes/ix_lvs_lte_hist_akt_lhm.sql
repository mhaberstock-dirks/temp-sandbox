create index dirkspzm32.ix_lvs_lte_hist_akt_lhm on
    dirkspzm32.lvs_lte_hist (
        lte_akt_lhm
    );


-- sqlcl_snapshot {"hash":"fb5a01d132bdc5d7df42a6482a855edb8fbd8e7a","type":"INDEX","name":"IX_LVS_LTE_HIST_AKT_LHM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_AKT_LHM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_AKT_LHM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}