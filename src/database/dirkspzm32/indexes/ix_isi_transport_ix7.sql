create index dirkspzm32.ix_isi_transport_ix7 on
    dirkspzm32.isi_transport (
        auf_id,
        transp_id
    );


-- sqlcl_snapshot {"hash":"d055e40aab7665a8479fbc9b92f3a68e24ede840","type":"INDEX","name":"IX_ISI_TRANSPORT_IX7","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_IX7</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TRANSP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}