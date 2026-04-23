create index dirkspzm32.ix_lam_bh_vorgang_id on
    dirkspzm32.lvs_lam_bh (
        vorg_id
    );


-- sqlcl_snapshot {"hash":"35557ed4ebdbb2b1d5c7d40ad0ad4d5277600789","type":"INDEX","name":"IX_LAM_BH_VORGANG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_VORGANG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}