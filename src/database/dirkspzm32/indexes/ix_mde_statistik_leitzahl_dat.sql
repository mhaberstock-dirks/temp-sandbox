create index dirkspzm32.ix_mde_statistik_leitzahl_dat on
    dirkspzm32.mde_statistik (
        leitzahl,
        datum
    );


-- sqlcl_snapshot {"hash":"0a997d545161ed47b5497d8078afa6e907009bea","type":"INDEX","name":"IX_MDE_STATISTIK_LEITZAHL_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MDE_STATISTIK_LEITZAHL_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MDE_STATISTIK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}