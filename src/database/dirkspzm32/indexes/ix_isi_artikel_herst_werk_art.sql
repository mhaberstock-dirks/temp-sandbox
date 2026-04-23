create unique index dirkspzm32.ix_isi_artikel_herst_werk_art on
    dirkspzm32.isi_artikel_hersteller_werk (
        artikel_id,
        artikel_hersteller_werk_id,
        herstellerkuerzel,
        sid
    );


-- sqlcl_snapshot {"hash":"ef7ae4df3bad4811b60db8d14e69baa92af22e6e","type":"INDEX","name":"IX_ISI_ARTIKEL_HERST_WERK_ART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ARTIKEL_HERST_WERK_ART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_HERSTELLER_WERK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_HERSTELLER_WERK_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HERSTELLERKUERZEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}