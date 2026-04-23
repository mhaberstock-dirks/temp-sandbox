create index dirkspzm32.ix_lam_order_auf_id_hist on
    dirkspzm32.lvs_lam_hist (
        sid,
        order_pos_auf_id
    );


-- sqlcl_snapshot {"hash":"f7d854819e9c267189b42e95c0bdd83e78a015f2","type":"INDEX","name":"IX_LAM_ORDER_AUF_ID_HIST","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_ORDER_AUF_ID_HIST</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_POS_AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}