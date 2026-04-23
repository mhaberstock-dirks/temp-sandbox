create index dirkspzm32.ix_s_res_fa_auftrag_status on
    dirkspzm32.s_rcv_fa_auf (
        ag_status,
        auf_id
    );


-- sqlcl_snapshot {"hash":"18377ae0c5173c3a7b0700700417c0281829e466","type":"INDEX","name":"IX_S_RES_FA_AUFTRAG_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RES_FA_AUFTRAG_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_FA_AUF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AG_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}