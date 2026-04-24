create index dirkspzm32.ix_isi_order_pos_vorg_artikel on
    dirkspzm32.isi_order_pos (
        vorgang_id,
        artikel_id
    );


-- sqlcl_snapshot {"hash":"4efb35ce11b9369506aab0c6b7065a7db406b8b3","type":"INDEX","name":"IX_ISI_ORDER_POS_VORG_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_POS_VORG_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}