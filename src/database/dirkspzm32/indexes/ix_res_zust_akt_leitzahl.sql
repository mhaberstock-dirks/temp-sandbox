create index dirkspzm32.ix_res_zust_akt_leitzahl on
    dirkspzm32.isi_resource_zust_akt (
        leitzahl,
        fa_ag,
        fa_upos,
        res_id
    );


-- sqlcl_snapshot {"hash":"a7135df7bfdd2b3557c6162abb9461cad6775d56","type":"INDEX","name":"IX_RES_ZUST_AKT_LEITZAHL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_ZUST_AKT_LEITZAHL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RESOURCE_ZUST_AKT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}