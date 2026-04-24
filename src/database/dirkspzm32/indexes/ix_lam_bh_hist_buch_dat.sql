create index dirkspzm32.ix_lam_bh_hist_buch_dat on
    dirkspzm32.lvs_lam_bh_hist (
        buch_datum
    );


-- sqlcl_snapshot {"hash":"389e202a91744ca7638c2b698987227a6a6d0622","type":"INDEX","name":"IX_LAM_BH_HIST_BUCH_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_HIST_BUCH_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>BUCH_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}