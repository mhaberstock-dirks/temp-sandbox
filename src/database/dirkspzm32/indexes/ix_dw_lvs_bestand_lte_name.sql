create index dirkspzm32.ix_dw_lvs_bestand_lte_name on
    dirkspzm32.dw_lvs_bestand (
        erfasst_am,
        lte_name,
        stat_name
    );


-- sqlcl_snapshot {"hash":"5375d067f6204c75c9d5e8ffbd1816602626058c","type":"INDEX","name":"IX_DW_LVS_BESTAND_LTE_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_LTE_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LTE_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}