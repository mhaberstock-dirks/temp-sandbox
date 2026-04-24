create index dirkspzm32.ix_aps_order_materialrel_child on
    dirkspzm32.aps_order_materialrelation (
        child_id,
        aps_plan_status
    );


-- sqlcl_snapshot {"hash":"1ae0b0698aeaa3a49d788a9a0650e2db6194b253","type":"INDEX","name":"IX_APS_ORDER_MATERIALREL_CHILD","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_MATERIALREL_CHILD</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_MATERIALRELATION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHILD_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}