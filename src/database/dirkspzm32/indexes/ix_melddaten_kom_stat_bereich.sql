create index dirkspzm32.ix_melddaten_kom_stat_bereich on
    dirkspzm32.meldung_daten (
        md_kommt,
        md_status,
        md_bereich
    );


-- sqlcl_snapshot {"hash":"7a4e6aa48f952696b97c6f9b60eadc0b354970d1","type":"INDEX","name":"IX_MELDDATEN_KOM_STAT_BEREICH","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_MELDDATEN_KOM_STAT_BEREICH</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MELDUNG_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MD_KOMMT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MD_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MD_BEREICH</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}