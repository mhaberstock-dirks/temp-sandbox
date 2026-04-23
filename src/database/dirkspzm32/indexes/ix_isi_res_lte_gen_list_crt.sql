create index dirkspzm32.ix_isi_res_lte_gen_list_crt on
    dirkspzm32.isi_res_lte_gen_list (
        created_date
    );


-- sqlcl_snapshot {"hash":"7170390cef693a99107de1dc7dd0ed21a1b168b9","type":"INDEX","name":"IX_ISI_RES_LTE_GEN_LIST_CRT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_RES_LTE_GEN_LIST_CRT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_LTE_GEN_LIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CREATED_DATE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}