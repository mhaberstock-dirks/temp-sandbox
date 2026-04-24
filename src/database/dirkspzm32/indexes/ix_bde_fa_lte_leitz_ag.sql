create index dirkspzm32.ix_bde_fa_lte_leitz_ag on
    dirkspzm32.bde_fa_auftrag_lte_pool (
        leitzahl,
        lte_id,
        lte_verwendet
    );


-- sqlcl_snapshot {"hash":"cea6f2ba5d9f7ac3bfddf302a0e84eb4fbbb7fec","type":"INDEX","name":"IX_BDE_FA_LTE_LEITZ_AG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_LTE_LEITZ_AG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_LTE_POOL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_VERWENDET</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}