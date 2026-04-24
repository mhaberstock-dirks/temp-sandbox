create index dirkspzm32.ix_lvs_lgr_ort_verfuegbar on
    dirkspzm32.lvs_lgr (
        lgr_ort,
        gesperrt,
        lgr_einl_te_verfueg
    );


-- sqlcl_snapshot {"hash":"6dc510443389d208eee1f7bfba10e3b9ed30230f","type":"INDEX","name":"IX_LVS_LGR_ORT_VERFUEGBAR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_ORT_VERFUEGBAR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GESPERRT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_EINL_TE_VERFUEG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}