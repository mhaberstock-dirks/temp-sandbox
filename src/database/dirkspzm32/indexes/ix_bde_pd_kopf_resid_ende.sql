create index dirkspzm32.ix_bde_pd_kopf_resid_ende on
    dirkspzm32.bde_pd_kopf (
        res_id,
        pd_kopf_ende
    );


-- sqlcl_snapshot {"hash":"d10882e287faf04939f31bacd0e21fb8d849b26b","type":"INDEX","name":"IX_BDE_PD_KOPF_RESID_ENDE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_KOPF_RESID_ENDE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PD_KOPF_ENDE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}