create unique index dirkspzm32.ix_s_ess_qad_send_bew_date on
    dirkspzm32.s_essex_qad_send_bew (
        b_date,
        ts
    );


-- sqlcl_snapshot {"hash":"3491fb3f0d1d143e0bcb120d521691f369f19c2f","type":"INDEX","name":"IX_S_ESS_QAD_SEND_BEW_DATE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ESS_QAD_SEND_BEW_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ESSEX_QAD_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>B_DATE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}