create index dirkspzm32.ix_pps_arb_plan_ag_res_liste on
    dirkspzm32.pps_arb_plan_ag_res_id_liste (
        arb_plan_id,
        vorgang,
        pos_nr,
        ag_upos,
        res_id
    );


-- sqlcl_snapshot {"hash":"345d32ba6a29e7162f2d1352c23b48b15a58eea8","type":"INDEX","name":"IX_PPS_ARB_PLAN_AG_RES_LISTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_ARB_PLAN_AG_RES_LISTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_ARB_PLAN_AG_RES_ID_LISTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARB_PLAN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AG_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}