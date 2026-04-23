create index dirkspzm32.ix_lvs_lgr_platz_kg_gruppe on
    dirkspzm32.lvs_lgr (
        lgr_kg_gruppe
    );


-- sqlcl_snapshot {"hash":"be06424a6fca731cdf9eeaeceac452adf1f1d7b8","type":"INDEX","name":"IX_LVS_LGR_PLATZ_KG_GRUPPE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_PLATZ_KG_GRUPPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_KG_GRUPPE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}