create index dirkspzm32.ix_dw_lvs_bestand_erfassung on
    dirkspzm32.dw_lvs_bestand (
        erfasst_am,
        stat_name
    );


-- sqlcl_snapshot {"hash":"5261af1b23a61d9ea5fbc5a8883c720fab2f6e7b","type":"INDEX","name":"IX_DW_LVS_BESTAND_ERFASSUNG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_ERFASSUNG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}