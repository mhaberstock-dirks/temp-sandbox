create index dirkspzm32.ix_s_eus_sap_send_bew_tab_leit on
    dirkspzm32.s_eus_sap_send_bew (
        tabelle,
        leitzahl
    );


-- sqlcl_snapshot {"hash":"bcd57a8333636a3067aa05db80d3eaac8ee39c8a","type":"INDEX","name":"IX_S_EUS_SAP_SEND_BEW_TAB_LEIT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_EUS_SAP_SEND_BEW_TAB_LEIT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_EUS_SAP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TABELLE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}