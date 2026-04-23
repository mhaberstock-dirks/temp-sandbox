create index dirkspzm32.ix_lvs_lgr_ort_ue_platz_platz on
    dirkspzm32.lvs_lgr_ort_ue_platz (
        lgr_platz,
        lgr_ort_quelle
    );


-- sqlcl_snapshot {"hash":"999ae684a1b8c987387d49babc63d56f1e1394cf","type":"INDEX","name":"IX_LVS_LGR_ORT_UE_PLATZ_PLATZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_ORT_UE_PLATZ_PLATZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR_ORT_UE_PLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_QUELLE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}