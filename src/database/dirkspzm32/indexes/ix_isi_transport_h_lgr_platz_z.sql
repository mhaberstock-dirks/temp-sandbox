create index dirkspzm32.ix_isi_transport_h_lgr_platz_z on
    dirkspzm32.isi_transport_hist (
        lgr_platz_ziel
    );


-- sqlcl_snapshot {"hash":"73c9b920cee204f6851f4486f2bf1c009c62c730","type":"INDEX","name":"IX_ISI_TRANSPORT_H_LGR_PLATZ_Z","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_H_LGR_PLATZ_Z</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ_ZIEL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}