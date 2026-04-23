create index dirkspzm32.ix_lam_stl_daten_lam_id on
    dirkspzm32.bde_pd_lam_stl_daten (
        fert_lam_id,
        pd_lam_stl_daten_id
    );


-- sqlcl_snapshot {"hash":"bd3b4085da2d3b18d560b5d15982835603c08c89","type":"INDEX","name":"IX_LAM_STL_DATEN_LAM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_STL_DATEN_LAM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_LAM_STL_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FERT_LAM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PD_LAM_STL_DATEN_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}