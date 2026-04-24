create index dirkspzm32.ix_bde_pd_prod_lam_id on
    dirkspzm32.bde_pd_prod (
        lam_id
    );


-- sqlcl_snapshot {"hash":"a9b646c887c24004c2662ea3f2ba66f7201c5052","type":"INDEX","name":"IX_BDE_PD_PROD_LAM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROD_LAM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}