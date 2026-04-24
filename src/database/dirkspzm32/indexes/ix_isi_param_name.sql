create index dirkspzm32.ix_isi_param_name on
    dirkspzm32.isi_params_cfg (
        param_name
    );


-- sqlcl_snapshot {"hash":"a3e7cb50e640a3dae862360780ccd6da6ab48edf","type":"INDEX","name":"IX_ISI_PARAM_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_PARAM_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_PARAMS_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PARAM_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}