create index dirkspzm32.ix_lz_alternativ_loa on
    dirkspzm32.pzm_lohnarten (
        lz_alternativ_loa_id,
        lz_id
    );


-- sqlcl_snapshot {"hash":"221b4815498dacdc65a4dea4f2345d91ec12a29a","type":"INDEX","name":"IX_LZ_ALTERNATIV_LOA","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LZ_ALTERNATIV_LOA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_LOHNARTEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LZ_ALTERNATIV_LOA_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LZ_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}