create index dirkspzm32.ix_melddatum_kommt on
    dirkspzm32.meldung_daten (
        md_kommt
    );


-- sqlcl_snapshot {"hash":"d5276107b14e8fb8eab56f2c12b8a3d527e03032","type":"INDEX","name":"IX_MELDDATUM_KOMMT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MELDDATUM_KOMMT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MELDUNG_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MD_KOMMT</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}