create index dirkspzm32.ix_pps_plan_auftrag_ix2 on
    dirkspzm32.pps_plan_auftrag (
        status,
        plan_auf_id
    );


-- sqlcl_snapshot {"hash":"b2551d80232447f07cbcd4d38afbcb8bb1400f7d","type":"INDEX","name":"IX_PPS_PLAN_AUFTRAG_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_PLAN_AUFTRAG_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_PLAN_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}