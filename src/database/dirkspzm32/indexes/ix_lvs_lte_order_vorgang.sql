create index dirkspzm32.ix_lvs_lte_order_vorgang on
    dirkspzm32.lvs_lte (
        order_vorgang_id
    );


-- sqlcl_snapshot {"hash":"86f410424e3fc2c9158ceabca63866b71225a5b9","type":"INDEX","name":"IX_LVS_LTE_ORDER_VORGANG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_ORDER_VORGANG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}