create index dirkspzm32.ix_pzm_ze_loa_exp_ext_gutsch_datum on
    dirkspzm32.pzm_ze_loa_exp_ext_gutsch (
        datum
    );


-- sqlcl_snapshot {"hash":"e01475f310a14ba687f7229537af177dbff20323","type":"INDEX","name":"IX_PZM_ZE_LOA_EXP_EXT_GUTSCH_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PZM_ZE_LOA_EXP_EXT_GUTSCH_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_LOA_EXP_EXT_GUTSCH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}