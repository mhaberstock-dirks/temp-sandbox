create index dirkspzm32.ix_artikel_gruppe on
    dirkspzm32.isi_artikel_gruppe (
        art_gruppe
    );


-- sqlcl_snapshot {"hash":"ded3302bbcd6fdd5c8e8da39adf7054197ebb828","type":"INDEX","name":"IX_ARTIKEL_GRUPPE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ARTIKEL_GRUPPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_GRUPPE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ART_GRUPPE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}