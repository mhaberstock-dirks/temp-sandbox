create index dirkspzm32.ix_ze_ts_datum on
    dirkspzm32.pzm_ze_tagessatz (
        ts_datum
    );


-- sqlcl_snapshot {"hash":"de11049d27ac0e3149cde5acb72c9ac76f775aa5","type":"INDEX","name":"IX_ZE_TS_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_TS_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_TAGESSATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TS_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}