create index dirkspzm32.ix_lvs_lam_kunde on
    dirkspzm32.lvs_lam (
        kunden_nr
    );


-- sqlcl_snapshot {"hash":"fda440f5aff702954ca175d8f07664dd5e429554","type":"INDEX","name":"IX_LVS_LAM_KUNDE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LAM_KUNDE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KUNDEN_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}