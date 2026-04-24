create index dirkspzm32.ix_lam_bh_artikel_buch_dat on
    dirkspzm32.lvs_lam_bh_hist (
        artikel_id,
        buch_datum
    );


-- sqlcl_snapshot {"hash":"a6d6001e732ab47dd1b8a754f0ea1387aa0ccde9","type":"INDEX","name":"IX_LAM_BH_ARTIKEL_BUCH_DAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_BH_ARTIKEL_BUCH_DAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_BH_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BUCH_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}