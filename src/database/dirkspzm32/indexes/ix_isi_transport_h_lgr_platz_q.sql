create index dirkspzm32.ix_isi_transport_h_lgr_platz_q on
    dirkspzm32.isi_transport_hist (
        lgr_platz_quelle
    );


-- sqlcl_snapshot {"hash":"5b49b21c8a7da0b97a463b5bfc156807a9072934","type":"INDEX","name":"IX_ISI_TRANSPORT_H_LGR_PLATZ_Q","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_H_LGR_PLATZ_Q</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ_QUELLE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}