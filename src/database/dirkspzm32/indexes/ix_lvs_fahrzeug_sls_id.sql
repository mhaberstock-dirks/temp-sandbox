create index dirkspzm32.ix_lvs_fahrzeug_sls_id on
    dirkspzm32.lvs_fahrzeuge (
        stapler_ls_id
    );


-- sqlcl_snapshot {"hash":"9f61aa2f8fcd18c803a9e20ffbe5c9bd4ff39f71","type":"INDEX","name":"IX_LVS_FAHRZEUG_SLS_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_FAHRZEUG_SLS_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_FAHRZEUGE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STAPLER_LS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}