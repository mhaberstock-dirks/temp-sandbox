create index dirkspzm32.ix_isi_lief_li_nr_v_lhm_id on
    dirkspzm32.isi_liefs (
        li_nr,
        v_lhm_id
    );


-- sqlcl_snapshot {"hash":"39a610f6638cff95f79f9b2c3398e2d7f47e4078","type":"INDEX","name":"IX_ISI_LIEF_LI_NR_V_LHM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_LIEF_LI_NR_V_LHM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_LIEFS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LI_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>V_LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}