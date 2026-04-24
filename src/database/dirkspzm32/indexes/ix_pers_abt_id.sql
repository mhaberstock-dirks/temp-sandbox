create index dirkspzm32.ix_pers_abt_id on
    dirkspzm32.pzm_personal (
        pers_abt_id
    );


-- sqlcl_snapshot {"hash":"afaafd6cfadf814bdbcfdf196aac9c8ed1385703","type":"INDEX","name":"IX_PERS_ABT_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PERS_ABT_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_PERSONAL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_ABT_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}