create index dirkspzm32.ix_komm_tnk_id on
    dirkspzm32.isi_komm_order (
        transp_id_nach_komm
    );


-- sqlcl_snapshot {"hash":"a89183d6694b475bdc3ec5b0d911bd6b7a311852","type":"INDEX","name":"IX_KOMM_TNK_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_TNK_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TRANSP_ID_NACH_KOMM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}