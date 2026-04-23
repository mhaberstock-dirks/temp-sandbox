create unique index dirkspzm32.pk_ctl_service_io on
    dirkspzm32.ctl_service_io (
        service_name
    );


-- sqlcl_snapshot {"hash":"3d3089c75b3ee93aa07092a6d5bc984e65db622c","type":"INDEX","name":"PK_CTL_SERVICE_IO","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PK_CTL_SERVICE_IO</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>CTL_SERVICE_IO</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SERVICE_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}