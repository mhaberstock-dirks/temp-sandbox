create index dirkspzm32.ix_pzm_ze_loa_exp_host_pb_id on
    dirkspzm32.pzm_ze_loa_exp_host (
        pb_id,
        pers_nr,
        datum,
        lohnart
    );


-- sqlcl_snapshot {"hash":"1175794c288f841b5598603353f121f58fe530e0","type":"INDEX","name":"IX_PZM_ZE_LOA_EXP_HOST_PB_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PZM_ZE_LOA_EXP_HOST_PB_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_LOA_EXP_HOST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PB_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOHNART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}