create index dirkspzm32.ix_isi_artikel_kunde_kunde_nr on
    dirkspzm32.isi_artikel_kunde (
        kunden_nr
    );


-- sqlcl_snapshot {"hash":"aa030e82ad3a3f625ee90cd048da177fd0070475","type":"INDEX","name":"IX_ISI_ARTIKEL_KUNDE_KUNDE_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ARTIKEL_KUNDE_KUNDE_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_KUNDE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KUNDEN_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}