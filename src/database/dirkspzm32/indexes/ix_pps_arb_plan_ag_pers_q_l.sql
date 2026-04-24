create index dirkspzm32.ix_pps_arb_plan_ag_pers_q_l on
    dirkspzm32.pps_arb_plan_ag_pers_q_list (
        arb_plan_id,
        vorgang,
        pos_nr,
        ag_upos,
        group_id
    );


-- sqlcl_snapshot {"hash":"b71f27ae1d11466fa07889212a49ac6eb04e00d8","type":"INDEX","name":"IX_PPS_ARB_PLAN_AG_PERS_Q_L","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_ARB_PLAN_AG_PERS_Q_L</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_ARB_PLAN_AG_PERS_Q_LIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARB_PLAN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AG_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GROUP_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}