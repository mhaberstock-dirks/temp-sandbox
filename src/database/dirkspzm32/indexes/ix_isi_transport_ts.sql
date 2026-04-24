create index dirkspzm32.ix_isi_transport_ts on
    dirkspzm32.isi_transport_hist (
        ts
    );


-- sqlcl_snapshot {"hash":"b08334935452268a3e07badc2ca7e8079487e591","type":"INDEX","name":"IX_ISI_TRANSPORT_TS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_TS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}