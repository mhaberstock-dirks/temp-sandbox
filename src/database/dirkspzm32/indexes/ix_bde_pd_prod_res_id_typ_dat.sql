create index dirkspzm32.ix_bde_pd_prod_res_id_typ_dat on
    dirkspzm32.bde_pd_prod (
        res_id,
        vorg_typ,
        prod_ende
    );


-- sqlcl_snapshot {"hash":"a6c098f8a39b805a056648e7c4d6c65856b7a15a","type":"INDEX","name":"IX_BDE_PD_PROD_RES_ID_TYP_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROD_RES_ID_TYP_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROD_ENDE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}