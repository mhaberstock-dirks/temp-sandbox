create index dirkspzm32.ix_rep_gruppe on
    dirkspzm32.rep_abfragen (
        rep_gruppe,
        rep_id
    );


-- sqlcl_snapshot {"hash":"f19c4518394adbef68d3cc9cc40c00cbfcb074f7","type":"INDEX","name":"IX_REP_GRUPPE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_REP_GRUPPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>REP_ABFRAGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REP_GRUPPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}