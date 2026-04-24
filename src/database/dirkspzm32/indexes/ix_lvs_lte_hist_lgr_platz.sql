create index dirkspzm32.ix_lvs_lte_hist_lgr_platz on
    dirkspzm32.lvs_lte_hist (
        lgr_platz
    );


-- sqlcl_snapshot {"hash":"8c61b5e790a162998eddaa449a248ca6d243f0fa","type":"INDEX","name":"IX_LVS_LTE_HIST_LGR_PLATZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_LGR_PLATZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}