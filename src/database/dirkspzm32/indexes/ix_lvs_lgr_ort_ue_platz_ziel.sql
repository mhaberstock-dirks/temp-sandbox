create unique index dirkspzm32.ix_lvs_lgr_ort_ue_platz_ziel on
    dirkspzm32.lvs_lgr_ort_ue_platz (
        lgr_ort_ziel,
        lgr_ort_quelle
    );


-- sqlcl_snapshot {"hash":"c34dddccfe107b7313929e362c61b17ff7498dc9","type":"INDEX","name":"IX_LVS_LGR_ORT_UE_PLATZ_ZIEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_ORT_UE_PLATZ_ZIEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR_ORT_UE_PLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_ZIEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_ORT_QUELLE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}