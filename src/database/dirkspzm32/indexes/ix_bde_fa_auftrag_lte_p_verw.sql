create unique index dirkspzm32.ix_bde_fa_auftrag_lte_p_verw on
    dirkspzm32.bde_fa_auftrag_lte_pool (
        lte_verwendet,
        lte_id
    );


-- sqlcl_snapshot {"hash":"4a64210a6733474a03ecc68b01407ca8251ba8a1","type":"INDEX","name":"IX_BDE_FA_AUFTRAG_LTE_P_VERW","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AUFTRAG_LTE_P_VERW</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_LTE_POOL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_VERWENDET</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}