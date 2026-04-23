create index dirkspzm32.ix_bde_pd_pers_kst_resid_ende on
    dirkspzm32.bde_pd_pers_zeit_kst (
        res_id,
        pd_pers_ende
    );


-- sqlcl_snapshot {"hash":"e78c818d0420cee359e0ffe47bc9100da555f757","type":"INDEX","name":"IX_BDE_PD_PERS_KST_RESID_ENDE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PERS_KST_RESID_ENDE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PERS_ZEIT_KST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PD_PERS_ENDE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}