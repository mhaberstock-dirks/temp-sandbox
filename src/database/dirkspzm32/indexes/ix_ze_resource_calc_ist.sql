create index dirkspzm32.ix_ze_resource_calc_ist on
    dirkspzm32.pzm_zeiterfassung (
        ze_pers_nr,
        ze_calc_ist_start,
        ze_calc_ist_ende
    );


-- sqlcl_snapshot {"hash":"ccc937ab57ab1094756bbdd44c9752ebc8610d21","type":"INDEX","name":"IX_ZE_RESOURCE_CALC_IST","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_RESOURCE_CALC_IST</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_CALC_IST_START</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_CALC_IST_ENDE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}