create index dirkspzm32.ix_isi_adressen_art_nr on
    dirkspzm32.isi_adressen (
        adr_art,
        adr_nr
    );


-- sqlcl_snapshot {"hash":"b57679ddc602b54590b617a9a0c10ffde0e2f084","type":"INDEX","name":"IX_ISI_ADRESSEN_ART_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ADRESSEN_ART_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ADRESSEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ADR_ART</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ADR_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}