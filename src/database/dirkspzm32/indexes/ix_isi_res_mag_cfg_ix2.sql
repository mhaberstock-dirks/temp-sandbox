create index dirkspzm32.ix_isi_res_mag_cfg_ix2 on
    dirkspzm32.isi_res_mag_cfg (
        artikel_id,
        res_id
    );


-- sqlcl_snapshot {"hash":"864cd7a6375778dbe7e7f2cb854c9b316bdfe0e5","type":"INDEX","name":"IX_ISI_RES_MAG_CFG_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_RES_MAG_CFG_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_MAG_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}