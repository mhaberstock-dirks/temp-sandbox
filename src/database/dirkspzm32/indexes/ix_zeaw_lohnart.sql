create index dirkspzm32.ix_zeaw_lohnart on
    dirkspzm32.pzm_ze_loa_ausw (
        zeaw_lz_lohnart
    );


-- sqlcl_snapshot {"hash":"87fafeedc11e9fac5aafc5a0e57a306ae9e84b64","type":"INDEX","name":"IX_ZEAW_LOHNART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZEAW_LOHNART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_LOA_AUSW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZEAW_LZ_LOHNART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}