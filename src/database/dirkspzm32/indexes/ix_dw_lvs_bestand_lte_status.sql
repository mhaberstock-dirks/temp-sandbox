create index dirkspzm32.ix_dw_lvs_bestand_lte_status on
    dirkspzm32.dw_lvs_bestand (
        lte_name,
        lte_status,
        stat_name,
        erfasst_am
    );


-- sqlcl_snapshot {"hash":"fbf61e6d495e3e93289441be4ec36cfbda94fbc4","type":"INDEX","name":"IX_DW_LVS_BESTAND_LTE_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_LTE_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}