create index dirkspzm32.ix_isi_transp_lgr_platz_z_zug on
    dirkspzm32.isi_transport (
        lgr_platz_ziel_check_new
    );


-- sqlcl_snapshot {"hash":"b9bb022399586c2b1b13aa3e3772845eb2c06c76","type":"INDEX","name":"IX_ISI_TRANSP_LGR_PLATZ_Z_ZUG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSP_LGR_PLATZ_Z_ZUG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ_ZIEL_CHECK_NEW</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}