create index dirkspzm32.ix_aps_order_auftr_pos_artikel on
    dirkspzm32.aps_order_auftr_pos (
        artikel_id
    );


-- sqlcl_snapshot {"hash":"f452c9d3862e9308bd8945584e6e737245ff56ac","type":"INDEX","name":"IX_APS_ORDER_AUFTR_POS_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_ORDER_AUFTR_POS_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_ORDER_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}