create index dirkspzm32.ix_lvs_lte_status_res_string on
    dirkspzm32.lvs_lte (
        lte_status,
        res_string
    );


-- sqlcl_snapshot {"hash":"92914f1beaa8282056166544dfd9e6d53ab36884","type":"INDEX","name":"IX_LVS_LTE_STATUS_RES_STRING","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_STATUS_RES_STRING</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_STRING</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}