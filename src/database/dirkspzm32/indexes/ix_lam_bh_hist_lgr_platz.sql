create index dirkspzm32.ix_lam_bh_hist_lgr_platz on
    dirkspzm32.lvs_lam_bh_hist (
        lgr_platz
    );


-- sqlcl_snapshot {"hash":"7a66f47c02c2035a3508ab36a220e38dbced423e","type":"INDEX","name":"IX_LAM_BH_HIST_LGR_PLATZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_LGR_PLATZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}