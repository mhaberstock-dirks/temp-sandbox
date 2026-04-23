create index dirkspzm32.ix_zeaw_datum on
    dirkspzm32.pzm_ze_loa_ausw (
        zeaw_datum
    );


-- sqlcl_snapshot {"hash":"9b220d04eccc3db0196e0efdfaf6a0e4b62aabca","type":"INDEX","name":"IX_ZEAW_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZEAW_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_LOA_AUSW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZEAW_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}