create index dirkspzm32.ix_pps_prod_param_name on
    dirkspzm32.pps_prod_param_cfg (
        param_name
    );


-- sqlcl_snapshot {"hash":"d1070de6c946643a3117683a2602c01324659810","type":"INDEX","name":"IX_PPS_PROD_PARAM_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_PROD_PARAM_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_PROD_PARAM_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PARAM_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}