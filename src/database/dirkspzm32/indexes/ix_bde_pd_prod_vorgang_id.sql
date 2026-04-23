create index dirkspzm32.ix_bde_pd_prod_vorgang_id on
    dirkspzm32.bde_pd_prod (
        vorg_id
    );


-- sqlcl_snapshot {"hash":"8948b81d576cc2f751ba0723feb05e9188ed0b02","type":"INDEX","name":"IX_BDE_PD_PROD_VORGANG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROD_VORGANG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}