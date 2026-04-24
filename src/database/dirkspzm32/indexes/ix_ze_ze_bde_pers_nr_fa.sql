create index dirkspzm32.ix_ze_ze_bde_pers_nr_fa on
    dirkspzm32.pzm_ze_bde_zeiten (
        ze_bde_pers_nr,
        ze_bde_leitzahl,
        ze_bde_fa_ag,
        ze_bde_fa_upos
    );


-- sqlcl_snapshot {"hash":"9335c0b7f6879c8542ff0a280b9e6dd4b467063b","type":"INDEX","name":"IX_ZE_ZE_BDE_PERS_NR_FA","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_ZE_BDE_PERS_NR_FA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_BDE_ZEITEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}