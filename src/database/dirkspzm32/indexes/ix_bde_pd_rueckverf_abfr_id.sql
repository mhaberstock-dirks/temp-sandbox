create index dirkspzm32.ix_bde_pd_rueckverf_abfr_id on
    dirkspzm32.bde_pd_rueckverfolgung (
        abfr_id
    );


-- sqlcl_snapshot {"hash":"a547b657a0c2765059caad7f40f5756c1c3e87f2","type":"INDEX","name":"IX_BDE_PD_RUECKVERF_ABFR_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_RUECKVERF_ABFR_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_RUECKVERFOLGUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ABFR_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}