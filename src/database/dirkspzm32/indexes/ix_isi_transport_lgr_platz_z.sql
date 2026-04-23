create index dirkspzm32.ix_isi_transport_lgr_platz_z on
    dirkspzm32.isi_transport (
        lgr_platz_ziel
    );


-- sqlcl_snapshot {"hash":"96c24724e33c4ff79d3c34a9cc42148d06223e00","type":"INDEX","name":"IX_ISI_TRANSPORT_LGR_PLATZ_Z","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_LGR_PLATZ_Z</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ_ZIEL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}