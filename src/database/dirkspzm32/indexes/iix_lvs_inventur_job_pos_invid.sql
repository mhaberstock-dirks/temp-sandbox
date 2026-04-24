create index dirkspzm32.iix_lvs_inventur_job_pos_invid on
    dirkspzm32.lvs_inventur_job_pos (
        inventur_id
    );


-- sqlcl_snapshot {"hash":"5c81439630b07e82214f3b7235360c09bf00486f","type":"INDEX","name":"IIX_LVS_INVENTUR_JOB_POS_INVID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IIX_LVS_INVENTUR_JOB_POS_INVID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_INVENTUR_JOB_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>INVENTUR_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}