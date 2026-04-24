create index dirkspzm32.ix_nio_daten_nio_nr on
    dirkspzm32.bde_pd_nio_daten (
        nio_nr,
        nio_datum
    );


-- sqlcl_snapshot {"hash":"7c02246c4bc37ba9db43c2239feaddb65f5f8f78","type":"INDEX","name":"IX_NIO_DATEN_NIO_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_NIO_DATEN_NIO_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_NIO_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NIO_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NIO_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}