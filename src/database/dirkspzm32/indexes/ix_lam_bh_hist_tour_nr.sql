create index dirkspzm32.ix_lam_bh_hist_tour_nr on
    dirkspzm32.lvs_lam_bh_hist (
        vorgang_id
    );


-- sqlcl_snapshot {"hash":"bd7117be7efe0f82fbafc2f5683c17fe0e6f8097","type":"INDEX","name":"IX_LAM_BH_HIST_TOUR_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_TOUR_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}