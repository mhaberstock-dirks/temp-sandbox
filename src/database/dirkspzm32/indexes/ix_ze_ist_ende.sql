create index dirkspzm32.ix_ze_ist_ende on
    dirkspzm32.pzm_zeiterfassung (
        ze_ist_ende,
        ze_id
    );


-- sqlcl_snapshot {"hash":"aaee8d92a886aaea734d44ce8c6b0d4c87f91866","type":"INDEX","name":"IX_ZE_IST_ENDE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_IST_ENDE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_IST_ENDE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}