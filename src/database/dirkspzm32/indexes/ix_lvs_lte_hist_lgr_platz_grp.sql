create index dirkspzm32.ix_lvs_lte_hist_lgr_platz_grp on
    dirkspzm32.lvs_lte_hist (
        lgr_platz_gruppe
    );


-- sqlcl_snapshot {"hash":"b1a9029f1a57c1905aa8b66588ef9cf2740b0a21","type":"INDEX","name":"IX_LVS_LTE_HIST_LGR_PLATZ_GRP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_LGR_PLATZ_GRP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ_GRUPPE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}