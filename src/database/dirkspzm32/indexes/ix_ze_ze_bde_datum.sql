create index dirkspzm32.ix_ze_ze_bde_datum on
    dirkspzm32.pzm_ze_bde_zeiten (
        ze_bde_datum
    );


-- sqlcl_snapshot {"hash":"5dd1bac07b4c9d3e9af22e06bb7441c210163fda","type":"INDEX","name":"IX_ZE_ZE_BDE_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_ZE_BDE_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZE_BDE_ZEITEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_BDE_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}