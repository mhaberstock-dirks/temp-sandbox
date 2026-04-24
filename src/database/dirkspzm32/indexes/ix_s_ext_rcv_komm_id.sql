create index dirkspzm32.ix_s_ext_rcv_komm_id on
    dirkspzm32.isi_komm_order (
        s_ext_rcv_komm_id
    );


-- sqlcl_snapshot {"hash":"efe51204d818c7a4b59b1ea63babc4e461b680b6","type":"INDEX","name":"IX_S_EXT_RCV_KOMM_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_EXT_RCV_KOMM_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>S_EXT_RCV_KOMM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}