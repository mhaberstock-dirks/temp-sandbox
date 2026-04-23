create index dirkspzm32.ix_lam_bh_tour_nr on
    dirkspzm32.lvs_lam_bh (
        vorgang_id
    );


-- sqlcl_snapshot {"hash":"3b2d2eaac42d7507deda59eaa92f9cc8b4aec15a","type":"INDEX","name":"IX_LAM_BH_TOUR_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_TOUR_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}