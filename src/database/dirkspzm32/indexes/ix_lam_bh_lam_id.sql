create index dirkspzm32.ix_lam_bh_lam_id on
    dirkspzm32.lvs_lam_bh (
        lam_id
    );


-- sqlcl_snapshot {"hash":"4c7a7f17e519fcb17579eff4b4b146da279d86ef","type":"INDEX","name":"IX_LAM_BH_LAM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_LAM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}