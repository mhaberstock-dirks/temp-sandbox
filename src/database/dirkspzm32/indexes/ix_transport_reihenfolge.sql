create index dirkspzm32.ix_transport_reihenfolge on
    dirkspzm32.isi_transport (
        freifahrauftrag
    desc,
        transport_reihenfolge,
        prio
    desc,
        transportmittel_id
    );


-- sqlcl_snapshot {"hash":"647bb1731511677d437dc6e55b0cf22e5c960c60","type":"INDEX","name":"IX_TRANSPORT_REIHENFOLGE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_TRANSPORT_REIHENFOLGE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>\"FREIFAHRAUFTRAG\"</NAME>\n            <DESC></DESC>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TRANSPORT_REIHENFOLGE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>\"PRIO\"</NAME>\n            <DESC></DESC>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TRANSPORTMITTEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}