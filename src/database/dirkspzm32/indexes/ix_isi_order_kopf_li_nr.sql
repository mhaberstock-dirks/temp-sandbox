create index dirkspzm32.ix_isi_order_kopf_li_nr on
    dirkspzm32.isi_order_kopf (
        li_nr,
        vorgang_id
    );


-- sqlcl_snapshot {"hash":"b7a89ea58be4f6a05d8109856aa1e0aeb38da3e7","type":"INDEX","name":"IX_ISI_ORDER_KOPF_LI_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ORDER_KOPF_LI_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ORDER_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LI_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}