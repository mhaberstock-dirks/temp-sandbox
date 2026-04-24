create index dirkspzm32.ix_aps_order_mat_rel_typ_c_art on
    dirkspzm32.aps_order_materialrelation (
        materialrelation_type,
        child_artikel_id,
        child_id,
        aps_plan_status
    );


-- sqlcl_snapshot {"hash":"e01b2df2d4b02a8dc9f276a553f1a8d24b67224f","type":"INDEX","name":"IX_APS_ORDER_MAT_REL_TYP_C_ART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_MAT_REL_TYP_C_ART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_MATERIALRELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MATERIALRELATION_TYPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}