create index dirkspzm32.ixpers_eintrittsdatum on
    dirkspzm32.pzm_personal (
        pers_eintrittsdatum
    );


-- sqlcl_snapshot {"hash":"d020e5ebc51c69ffa0b5711ced1f6bfe478938fb","type":"INDEX","name":"IXPERS_EINTRITTSDATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IXPERS_EINTRITTSDATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_PERSONAL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_EINTRITTSDATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}