create index dirkspzm32.ix_pzm_ze_loa_statistik_exp_host_datum on
    dirkspzm32.pzm_ze_loa_statistik_exp_host (
        datum
    );


-- sqlcl_snapshot {"hash":"3e64fae75ca647ae40bc627efcd92f89f85bb16f","type":"INDEX","name":"IX_PZM_ZE_LOA_STATISTIK_EXP_HOST_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PZM_ZE_LOA_STATISTIK_EXP_HOST_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_LOA_STATISTIK_EXP_HOST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}