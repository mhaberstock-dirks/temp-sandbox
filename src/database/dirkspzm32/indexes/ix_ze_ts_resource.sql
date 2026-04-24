create index dirkspzm32.ix_ze_ts_resource on
    dirkspzm32.pzm_ze_tagessatz (
        ts_pers_nr
    );


-- sqlcl_snapshot {"hash":"cb426bbd3cb14bca0ad29b600c5ceac15434f638","type":"INDEX","name":"IX_ZE_TS_RESOURCE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_TS_RESOURCE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_TAGESSATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TS_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}