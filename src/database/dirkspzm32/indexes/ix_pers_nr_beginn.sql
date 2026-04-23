create index dirkspzm32.ix_pers_nr_beginn on
    dirkspzm32.pzm_abwesenheitsmeldungen (
        pers_nr,
        beginn
    );


-- sqlcl_snapshot {"hash":"0b990fed9977132c69f4a02240b7f9ee40e0a1cb","type":"INDEX","name":"IX_PERS_NR_BEGINN","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PERS_NR_BEGINN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ABWESENHEITSMELDUNGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEGINN</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}