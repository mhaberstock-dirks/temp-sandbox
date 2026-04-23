create index dirkspzm32.ix_lam_order_auf_id on
    dirkspzm32.lvs_lam (
        order_pos_auf_id
    );


-- sqlcl_snapshot {"hash":"5dbe8f593f042a8fd5a1650be0b054e50fd60164","type":"INDEX","name":"IX_LAM_ORDER_AUF_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_ORDER_AUF_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_POS_AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}