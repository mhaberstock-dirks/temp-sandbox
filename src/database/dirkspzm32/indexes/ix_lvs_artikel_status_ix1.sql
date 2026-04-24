create index dirkspzm32.ix_lvs_artikel_status_ix1 on
    dirkspzm32.lvs_artikel_status (
        letzte_inventur_datum,
        artikel_id,
        artikel_status_id
    );


-- sqlcl_snapshot {"hash":"275ee52b5f45fe73ab3d3d48ec0c52979d7f2e0c","type":"INDEX","name":"IX_LVS_ARTIKEL_STATUS_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_ARTIKEL_STATUS_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_ARTIKEL_STATUS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LETZTE_INVENTUR_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_STATUS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}