create index dirkspzm32.ix_rep_name_gruppe on
    dirkspzm32.rep_abfragen ( upper(rep_name),
    upper(rep_gruppe) );


-- sqlcl_snapshot {"hash":"c82ffce660d9e0bcb8bdd2c43d3f7caad65cbec1","type":"INDEX","name":"IX_REP_NAME_GRUPPE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_REP_NAME_GRUPPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>REP_ABFRAGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>UPPER(\"REP_NAME\")</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPPER(\"REP_GRUPPE\")</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}