create unique index dirkspzm32.ix_isi_res_pruef_plan_data_cfg on
    dirkspzm32.isi_res_pruef_plan_data_cfg (
        res_id,
        res_teilgewerk,
        res_pruef_plan_data_nr,
        firma_nr,
        sid
    );


-- sqlcl_snapshot {"hash":"528bf8efdf44b0503db6b1318752b3b406abd2e1","type":"INDEX","name":"IX_ISI_RES_PRUEF_PLAN_DATA_CFG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_RES_PRUEF_PLAN_DATA_CFG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_PRUEF_PLAN_DATA_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_TEILGEWERK</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_PRUEF_PLAN_DATA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}