create index dirkspzm32.ix_pps_arb_plan_ag_op_rel on
    dirkspzm32.pps_arb_plan_ag_op_rel (
        arb_plan_id,
        vorgang,
        pos_nr,
        ag_upos,
        nvorgang,
        npos_nr,
        nag_upos,
        firma_nr,
        sid
    );


-- sqlcl_snapshot {"hash":"2b1ba8c28d096d7960e1745838b01a6a5e3ce1c4","type":"INDEX","name":"IX_PPS_ARB_PLAN_AG_OP_REL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PPS_ARB_PLAN_AG_OP_REL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_ARB_PLAN_AG_OP_REL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARB_PLAN_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AG_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NVORGANG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NPOS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NAG_UPOS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}