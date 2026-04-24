create index dirkspzm32.ix_bde_fa_ag_freigabe_status on
    dirkspzm32.bde_fa_auftrag (
        freig_status,
        firma_nr,
        sid
    );


-- sqlcl_snapshot {"hash":"2576fc175d5886e1306f8ba458970d70fb5118a0","type":"INDEX","name":"IX_BDE_FA_AG_FREIGABE_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AG_FREIGABE_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FREIG_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}