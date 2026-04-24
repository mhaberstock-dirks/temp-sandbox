create index dirkspzm32.ix_komm_tvk_id on
    dirkspzm32.isi_komm_order (
        transp_id_vor_komm
    );


-- sqlcl_snapshot {"hash":"5bbb5c1c871b3403353f082b5da589faf71339d9","type":"INDEX","name":"IX_KOMM_TVK_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_TVK_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TRANSP_ID_VOR_KOMM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}