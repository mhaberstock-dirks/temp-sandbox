create index dirkspzm32.ix_pps_arb_plan_ag_op_opg on
    dirkspzm32.pps_arb_plan_ag_op_opg (
        arb_plan_id,
        arb_plan_pos_id,
        vorgang,
        pos_nr,
        ag_upos
    );


-- sqlcl_snapshot {"hash":"ce3d109ed0ead193ecf3132627d1b2d85a893c52","type":"INDEX","name":"IX_PPS_ARB_PLAN_AG_OP_OPG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_ARB_PLAN_AG_OP_OPG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_ARB_PLAN_AG_OP_OPG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARB_PLAN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARB_PLAN_POS_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AG_UPOS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}