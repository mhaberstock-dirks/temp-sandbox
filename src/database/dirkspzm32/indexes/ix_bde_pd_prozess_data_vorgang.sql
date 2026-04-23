create index dirkspzm32.ix_bde_pd_prozess_data_vorgang on
    dirkspzm32.bde_pd_prozess_data (
        vorg_id
    );


-- sqlcl_snapshot {"hash":"90b9038fd0f6991b5a74464bc45b93a6ea6cd926","type":"INDEX","name":"IX_BDE_PD_PROZESS_DATA_VORGANG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROZESS_DATA_VORGANG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROZESS_DATA</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}