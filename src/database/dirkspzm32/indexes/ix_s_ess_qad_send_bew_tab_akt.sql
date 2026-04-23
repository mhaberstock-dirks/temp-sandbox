create index dirkspzm32.ix_s_ess_qad_send_bew_tab_akt on
    dirkspzm32.s_essex_qad_send_bew (
        tabelle,
        aktion
    );


-- sqlcl_snapshot {"hash":"3541174652e418771bd2cec1e5b3c49972bb9204","type":"INDEX","name":"IX_S_ESS_QAD_SEND_BEW_TAB_AKT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ESS_QAD_SEND_BEW_TAB_AKT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ESSEX_QAD_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TABELLE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AKTION</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}