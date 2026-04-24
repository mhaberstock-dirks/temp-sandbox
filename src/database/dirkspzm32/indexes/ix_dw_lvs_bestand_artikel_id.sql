create index dirkspzm32.ix_dw_lvs_bestand_artikel_id on
    dirkspzm32.dw_lvs_bestand (
        artikel_id,
        erfasst_am,
        stat_name
    );


-- sqlcl_snapshot {"hash":"ec63e4741d89b616d1e7f9367a1ab9e449dad187","type":"INDEX","name":"IX_DW_LVS_BESTAND_ARTIKEL_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_LVS_BESTAND_ARTIKEL_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_LVS_BESTAND</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERFASST_AM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STAT_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}