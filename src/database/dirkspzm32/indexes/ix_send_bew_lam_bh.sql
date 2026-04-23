create index dirkspzm32.ix_send_bew_lam_bh on
    dirkspzm32.s_send_bew (
        lam_bh_id
    );


-- sqlcl_snapshot {"hash":"7527fc96f7f4e316c561bc37e5c60cbf50afe87e","type":"INDEX","name":"IX_SEND_BEW_LAM_BH","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_SEND_BEW_LAM_BH</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LAM_BH_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}