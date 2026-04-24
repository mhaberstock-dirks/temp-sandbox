create index dirkspzm32.ix_isi_order_reord_h_ix3 on
    dirkspzm32.isi_order_reord_h (
        lhm_id,
        reord_id
    );


-- sqlcl_snapshot {"hash":"b342a43f73aecbe055bc2d5ab7799ed45d9af5bc","type":"INDEX","name":"IX_ISI_ORDER_REORD_H_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_REORD_H_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_REORD_H</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LHM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REORD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}