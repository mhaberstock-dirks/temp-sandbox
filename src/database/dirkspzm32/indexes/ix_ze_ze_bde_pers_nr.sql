create index dirkspzm32.ix_ze_ze_bde_pers_nr on
    dirkspzm32.pzm_ze_bde_zeiten (
        ze_bde_pers_nr
    );


-- sqlcl_snapshot {"hash":"c38472f8dc4f6f348a49ba81df343d407427e6ca","type":"INDEX","name":"IX_ZE_ZE_BDE_PERS_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_ZE_BDE_PERS_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_BDE_ZEITEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}