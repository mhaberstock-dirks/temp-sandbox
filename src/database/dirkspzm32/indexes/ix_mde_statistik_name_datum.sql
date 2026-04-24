create index dirkspzm32.ix_mde_statistik_name_datum on
    dirkspzm32.mde_statistik (
        name,
        datum
    );


-- sqlcl_snapshot {"hash":"54afa98dd7a62f568a11caee991de1ca9b9c4240","type":"INDEX","name":"IX_MDE_STATISTIK_NAME_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MDE_STATISTIK_NAME_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MDE_STATISTIK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}