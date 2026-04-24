create index dirkspzm32.ix_lam_stl_daten_fa on
    dirkspzm32.bde_pd_lam_stl_daten (
        fa_nr,
        fa_ag,
        fa_upos,
        fert_lam_id
    );


-- sqlcl_snapshot {"hash":"91ead68a8bc88287bc1c11fbeddc0ce0a7bea55b","type":"INDEX","name":"IX_LAM_STL_DATEN_FA","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_STL_DATEN_FA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_LAM_STL_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_AG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FERT_LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}