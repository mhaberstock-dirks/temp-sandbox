create index dirkspzm32.ix_nio_daten_nio_stat on
    dirkspzm32.bde_pd_nio_daten (
        nio_status,
        nio_nr
    );


-- sqlcl_snapshot {"hash":"bd201829bdb980a76fd50f4adcf27f16cb396e44","type":"INDEX","name":"IX_NIO_DATEN_NIO_STAT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_NIO_DATEN_NIO_STAT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_NIO_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NIO_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NIO_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}