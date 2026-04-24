create index dirkspzm32.ix_lvs_lte_hist_order_vorgang on
    dirkspzm32.lvs_lte_hist (
        order_vorgang_id
    );


-- sqlcl_snapshot {"hash":"36071de178c13e414535e88f68b4a267c23d1bae","type":"INDEX","name":"IX_LVS_LTE_HIST_ORDER_VORGANG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_ORDER_VORGANG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}