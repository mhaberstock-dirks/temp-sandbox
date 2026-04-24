create index dirkspzm32.ix_lam_bh_hist_leitzahl on
    dirkspzm32.lvs_lam_bh_hist (
        leitzahl
    );


-- sqlcl_snapshot {"hash":"fa9dc71c9dd95f7c2cc3cca704ae7c147e44ca85","type":"INDEX","name":"IX_LAM_BH_HIST_LEITZAHL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_LEITZAHL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}