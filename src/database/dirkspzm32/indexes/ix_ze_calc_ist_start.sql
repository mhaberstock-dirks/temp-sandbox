create index dirkspzm32.ix_ze_calc_ist_start on
    dirkspzm32.pzm_zeiterfassung (
        ze_calc_ist_start,
        ze_id
    );


-- sqlcl_snapshot {"hash":"a13ff7f122b33e6e6cca63ea3bfc49432d1806a1","type":"INDEX","name":"IX_ZE_CALC_IST_START","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ZE_CALC_IST_START</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ZEITERFASSUNG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZE_CALC_IST_START</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}