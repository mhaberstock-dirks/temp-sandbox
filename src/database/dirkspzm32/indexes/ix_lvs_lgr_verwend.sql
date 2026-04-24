create index dirkspzm32.ix_lvs_lgr_verwend on
    dirkspzm32.lvs_lgr (
        lgr_verwendung,
        lgr_platz,
        sid,
        firma_nr
    );


-- sqlcl_snapshot {"hash":"ad137877ef183500dda8f43a8dda7d07a5eb81f4","type":"INDEX","name":"IX_LVS_LGR_VERWEND","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_VERWEND</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_VERWENDUNG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}