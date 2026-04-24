create index dirkspzm32.ix_pps_arb_plan_ag_op_opg_id on
    dirkspzm32.pps_arb_plan_ag_op_opg (
        optimierungsgruppen_id
    );


-- sqlcl_snapshot {"hash":"0582e44ab28046893b83eeb7de9a84f393c29137","type":"INDEX","name":"IX_PPS_ARB_PLAN_AG_OP_OPG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_ARB_PLAN_AG_OP_OPG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_ARB_PLAN_AG_OP_OPG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>OPTIMIERUNGSGRUPPEN_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}