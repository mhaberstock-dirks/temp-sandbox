create index dirkspzm32.ix_lz_lohnart on
    dirkspzm32.pzm_lohnarten (
        lz_lohnart
    );


-- sqlcl_snapshot {"hash":"6e7b329655e4ca97494da63f00a764d96e0bf6ab","type":"INDEX","name":"IX_LZ_LOHNART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LZ_LOHNART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOHNARTEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LZ_LOHNART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}