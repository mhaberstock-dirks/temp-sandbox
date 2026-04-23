create index dirkspzm32.ix_res_zust_akt_fert_lam on
    dirkspzm32.isi_resource_zust_akt (
        fert_lam_id,
        res_id
    );


-- sqlcl_snapshot {"hash":"45387b2e46f3c1f79058c209be98acab470b0164","type":"INDEX","name":"IX_RES_ZUST_AKT_FERT_LAM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_ZUST_AKT_FERT_LAM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RESOURCE_ZUST_AKT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FERT_LAM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}