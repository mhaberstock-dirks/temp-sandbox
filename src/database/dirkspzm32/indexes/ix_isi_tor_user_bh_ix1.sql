create index dirkspzm32.ix_isi_tor_user_bh_ix1 on
    dirkspzm32.isi_tor_user_bh (
        zutritt_zeit,
        zutritt
    );


-- sqlcl_snapshot {"hash":"c02ecee410f994c1f2be600142d5e4ce5cc32a71","type":"INDEX","name":"IX_ISI_TOR_USER_BH_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TOR_USER_BH_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TOR_USER_BH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZUTRITT_ZEIT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZUTRITT</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}