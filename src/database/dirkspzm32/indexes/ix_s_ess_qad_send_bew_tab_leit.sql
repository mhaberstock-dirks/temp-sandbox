create index dirkspzm32.ix_s_ess_qad_send_bew_tab_leit on
    dirkspzm32.s_essex_qad_send_bew (
        tabelle,
        leitzahl
    );


-- sqlcl_snapshot {"hash":"e377b3ac7a8e5280cf3d2e77c1f0d50c6e0a2488","type":"INDEX","name":"IX_S_ESS_QAD_SEND_BEW_TAB_LEIT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ESS_QAD_SEND_BEW_TAB_LEIT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ESSEX_QAD_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TABELLE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}