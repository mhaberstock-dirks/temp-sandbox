create index dirkspzm32.ix_aps_plan_op_a_mat_r_typ on
    dirkspzm32.aps_plan_op_a_mat_relation (
        materialrelation_type,
        aps_plan_status
    );


-- sqlcl_snapshot {"hash":"a2749a0761028d5f15eaacd8e172f4afce670209","type":"INDEX","name":"IX_APS_PLAN_OP_A_MAT_R_TYP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_PLAN_OP_A_MAT_R_TYP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_PLAN_OP_A_MAT_RELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MATERIALRELATION_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}