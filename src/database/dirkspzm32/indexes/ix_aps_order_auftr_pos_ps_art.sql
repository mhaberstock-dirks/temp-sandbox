create index dirkspzm32.ix_aps_order_auftr_pos_ps_art on
    dirkspzm32.aps_order_auftr_pos (
        aps_plan_status,
        artikel_id
    );


-- sqlcl_snapshot {"hash":"0dec231eaf36eb9bd2e0f4711a9402c9f3d27ede","type":"INDEX","name":"IX_APS_ORDER_AUFTR_POS_PS_ART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_AUFTR_POS_PS_ART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APS_PLAN_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}