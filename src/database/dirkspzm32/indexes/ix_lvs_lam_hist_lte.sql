create index dirkspzm32.ix_lvs_lam_hist_lte on
    dirkspzm32.lvs_lam_hist (
        lte_id
    );


-- sqlcl_snapshot {"hash":"f27e7fd84dd121c364c6ae58cb78981768375365","type":"INDEX","name":"IX_LVS_LAM_HIST_LTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LAM_HIST_LTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}