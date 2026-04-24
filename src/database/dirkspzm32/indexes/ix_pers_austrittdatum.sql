create index dirkspzm32.ix_pers_austrittdatum on
    dirkspzm32.pzm_personal (
        pers_austrittdatum
    );


-- sqlcl_snapshot {"hash":"8446cd5964e35d268c3f51b3b50a45426a86f01a","type":"INDEX","name":"IX_PERS_AUSTRITTDATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PERS_AUSTRITTDATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_PERSONAL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_AUSTRITTDATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}