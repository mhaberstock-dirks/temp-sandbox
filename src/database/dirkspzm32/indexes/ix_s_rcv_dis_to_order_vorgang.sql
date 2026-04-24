create index dirkspzm32.ix_s_rcv_dis_to_order_vorgang on
    dirkspzm32.s_rcv_dis_to_order (
        satzart,
        vorgang_id
    );


-- sqlcl_snapshot {"hash":"82f86f6ecec15049c1d530f06e342bd1b939ce9e","type":"INDEX","name":"IX_S_RCV_DIS_TO_ORDER_VORGANG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RCV_DIS_TO_ORDER_VORGANG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_DIS_TO_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SATZART</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}