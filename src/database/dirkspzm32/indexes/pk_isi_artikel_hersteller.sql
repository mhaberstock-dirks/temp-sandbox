create unique index dirkspzm32.pk_isi_artikel_hersteller on
    dirkspzm32.isi_artikel_hersteller (
        artikel_id,
        herstellerkuerzel,
        sid
    );


-- sqlcl_snapshot {"hash":"4dbac949711efffa204492a3283cb56dddc6011f","type":"INDEX","name":"PK_ISI_ARTIKEL_HERSTELLER","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>PK_ISI_ARTIKEL_HERSTELLER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_HERSTELLER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HERSTELLERKUERZEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}