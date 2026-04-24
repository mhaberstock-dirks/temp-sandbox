create index dirkspzm32.ix_bde_pd_prozess_data_leit on
    dirkspzm32.bde_pd_prozess_data (
        leitzahl
    );


-- sqlcl_snapshot {"hash":"94f76adcc89539b66e35b3beb765e1ac3c8a836e","type":"INDEX","name":"IX_BDE_PD_PROZESS_DATA_LEIT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROZESS_DATA_LEIT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROZESS_DATA</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}