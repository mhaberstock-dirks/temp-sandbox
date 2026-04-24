create index dirkspzm32.ix_meldung_cfg_name on
    dirkspzm32.meldung_cfg (
        name
    );


-- sqlcl_snapshot {"hash":"5c8b47535a5ed0082a250b7ce913a5565b0465cf","type":"INDEX","name":"IX_MELDUNG_CFG_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MELDUNG_CFG_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MELDUNG_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}