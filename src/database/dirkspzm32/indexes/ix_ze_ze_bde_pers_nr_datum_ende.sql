create index dirkspzm32.ix_ze_ze_bde_pers_nr_datum_ende on
    dirkspzm32.pzm_ze_bde_zeiten (
        ze_bde_pers_nr,
        ze_bde_basis,
        ze_bde_day_ist_ende
    );


-- sqlcl_snapshot {"hash":"914e53589799b48b3057cd8d83eec9111937b17d","type":"INDEX","name":"IX_ZE_ZE_BDE_PERS_NR_DATUM_ENDE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_ZE_BDE_PERS_NR_DATUM_ENDE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_BDE_ZEITEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_BASIS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_DAY_IST_ENDE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}