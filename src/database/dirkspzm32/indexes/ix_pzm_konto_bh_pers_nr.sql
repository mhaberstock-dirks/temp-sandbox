create index dirkspzm32.ix_pzm_konto_bh_pers_nr on
    dirkspzm32.pzm_konten_bh (
        pers_nr,
        konten_bh_id
    );


-- sqlcl_snapshot {"hash":"7d73b5ea749a5b500bad5de427530330b66df2d5","type":"INDEX","name":"IX_PZM_KONTO_BH_PERS_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PZM_KONTO_BH_PERS_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_KONTEN_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KONTEN_BH_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}