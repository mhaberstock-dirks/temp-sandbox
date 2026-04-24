create index dirkspzm32.ix_bde_pd_prozess_data_io_val on
    dirkspzm32.bde_pd_prozess_data (
        io,
        res_prozess_data_res_id,
        res_prozess_data_value,
        fae_id
    );


-- sqlcl_snapshot {"hash":"485a75a473033c6d3ccdd5d32e6ff68d989b00a3","type":"INDEX","name":"IX_BDE_PD_PROZESS_DATA_IO_VAL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROZESS_DATA_IO_VAL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROZESS_DATA</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>IO</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_PROZESS_DATA_RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_PROZESS_DATA_VALUE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FAE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}