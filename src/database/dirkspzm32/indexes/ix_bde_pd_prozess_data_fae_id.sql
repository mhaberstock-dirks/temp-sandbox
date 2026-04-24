create index dirkspzm32.ix_bde_pd_prozess_data_fae_id on
    dirkspzm32.bde_pd_prozess_data (
        fae_id,
        leitzahl
    );


-- sqlcl_snapshot {"hash":"3c7cb42d0e7178966fdac49f215ca9bc01331602","type":"INDEX","name":"IX_BDE_PD_PROZESS_DATA_FAE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROZESS_DATA_FAE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROZESS_DATA</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FAE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}