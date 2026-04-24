create index dirkspzm32.ix_pps_plan_auftrag_ag_fhm_ix2 on
    dirkspzm32.pps_plan_auftrag_ag_fhm (
        plan_auf_ag_id,
        firma_nr,
        sid
    );


-- sqlcl_snapshot {"hash":"8dfad1cb59351589bc4307f777af880a8e6c2f23","type":"INDEX","name":"IX_PPS_PLAN_AUFTRAG_AG_FHM_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_PLAN_AUFTRAG_AG_FHM_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_PLAN_AUFTRAG_AG_FHM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PLAN_AUF_AG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}