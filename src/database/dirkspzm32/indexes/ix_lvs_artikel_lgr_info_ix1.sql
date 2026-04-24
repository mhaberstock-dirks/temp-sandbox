create index dirkspzm32.ix_lvs_artikel_lgr_info_ix1 on
    dirkspzm32.lvs_artikel_lgr_info (
        lgr_platz,
        artikel_id
    );


-- sqlcl_snapshot {"hash":"acd8855aee7c944837ebefb3f959d70b08aa5023","type":"INDEX","name":"IX_LVS_ARTIKEL_LGR_INFO_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_ARTIKEL_LGR_INFO_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_ARTIKEL_LGR_INFO</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}