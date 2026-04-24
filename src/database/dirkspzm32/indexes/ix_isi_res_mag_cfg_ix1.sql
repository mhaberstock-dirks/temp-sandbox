create index dirkspzm32.ix_isi_res_mag_cfg_ix1 on
    dirkspzm32.isi_res_mag_cfg (
        last_change_date,
        res_id
    );


-- sqlcl_snapshot {"hash":"0944a6c6912358fc3a61ae47a83c48ecb895125c","type":"INDEX","name":"IX_ISI_RES_MAG_CFG_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_RES_MAG_CFG_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_MAG_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LAST_CHANGE_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}