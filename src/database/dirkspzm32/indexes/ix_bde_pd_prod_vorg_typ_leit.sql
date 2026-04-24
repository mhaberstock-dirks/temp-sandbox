create index dirkspzm32.ix_bde_pd_prod_vorg_typ_leit on
    dirkspzm32.bde_pd_prod (
        vorg_typ,
        leitzahl,
        prod_ende
    );


-- sqlcl_snapshot {"hash":"8976b247d2623f1fa2bb9de531d567a0d9384c02","type":"INDEX","name":"IX_BDE_PD_PROD_VORG_TYP_LEIT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROD_VORG_TYP_LEIT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORG_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROD_ENDE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}