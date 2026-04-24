create index dirkspzm32.ix_ze_resource on
    dirkspzm32.pzm_zeiterfassung (
        ze_pers_nr,
        ze_id,
        ze_ist_start
    );


-- sqlcl_snapshot {"hash":"1b051a96177c359bac4ccfcd4b262aa72a5a1fec","type":"INDEX","name":"IX_ZE_RESOURCE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_RESOURCE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_IST_START</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}