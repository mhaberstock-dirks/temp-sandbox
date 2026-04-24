create index dirkspzm32.ix_s_erp_send_bew_tab_akt on
    dirkspzm32.s_erp_send_bew (
        tabelle,
        aktion
    );


-- sqlcl_snapshot {"hash":"9e768741ea1b576b5a9ce378860226fe2b163e93","type":"INDEX","name":"IX_S_ERP_SEND_BEW_TAB_AKT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ERP_SEND_BEW_TAB_AKT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ERP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TABELLE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AKTION</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}