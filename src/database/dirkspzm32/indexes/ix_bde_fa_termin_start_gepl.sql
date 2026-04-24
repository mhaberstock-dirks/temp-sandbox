create index dirkspzm32.ix_bde_fa_termin_start_gepl on
    dirkspzm32.bde_fa_auftrag (
        termin_start_gepl
    );


-- sqlcl_snapshot {"hash":"b8e1243fc04ff87cbbea4290e5ddb0b6b8d7b88d","type":"INDEX","name":"IX_BDE_FA_TERMIN_START_GEPL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_TERMIN_START_GEPL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TERMIN_START_GEPL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}