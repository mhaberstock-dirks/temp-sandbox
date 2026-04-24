create index dirkspzm32.ix_ze_resource_schicht_tag on
    dirkspzm32.pzm_zeiterfassung (
        ze_pers_nr,
        ze_schicht_tag
    );


-- sqlcl_snapshot {"hash":"85b7d20919715d1dd1ac2949429d86cd580139cf","type":"INDEX","name":"IX_ZE_RESOURCE_SCHICHT_TAG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_RESOURCE_SCHICHT_TAG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_SCHICHT_TAG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}