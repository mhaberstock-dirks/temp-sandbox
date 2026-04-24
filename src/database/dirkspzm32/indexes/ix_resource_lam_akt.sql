create index dirkspzm32.ix_resource_lam_akt on
    dirkspzm32.isi_resource_lam_akt (
        res_id
    );


-- sqlcl_snapshot {"hash":"df46a9d692cd8ee35b8f0c970c9d2ab72b396d4e","type":"INDEX","name":"IX_RESOURCE_LAM_AKT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RESOURCE_LAM_AKT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RESOURCE_LAM_AKT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}