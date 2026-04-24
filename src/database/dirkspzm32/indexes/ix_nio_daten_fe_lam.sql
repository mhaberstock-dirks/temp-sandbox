create index dirkspzm32.ix_nio_daten_fe_lam on
    dirkspzm32.bde_pd_nio_daten (
        fert_lam_id,
        pd_lam_stl_daten_id
    );


-- sqlcl_snapshot {"hash":"a6d3020410b87cfeee3ddafa5c9503b10eff4073","type":"INDEX","name":"IX_NIO_DATEN_FE_LAM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_NIO_DATEN_FE_LAM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_NIO_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FERT_LAM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PD_LAM_STL_DATEN_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}