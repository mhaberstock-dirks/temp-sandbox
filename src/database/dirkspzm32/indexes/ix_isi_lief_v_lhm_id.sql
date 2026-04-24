create index dirkspzm32.ix_isi_lief_v_lhm_id on
    dirkspzm32.isi_liefs (
        v_lhm_id,
        lhm_id
    );


-- sqlcl_snapshot {"hash":"fcba984af25a2d87093e08637a56f3ee00c1f6de","type":"INDEX","name":"IX_ISI_LIEF_V_LHM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_LIEF_V_LHM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_LIEFS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>V_LHM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}