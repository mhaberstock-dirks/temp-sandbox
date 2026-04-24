create index dirkspzm32.ix_bde_fa_ag_artikel_id on
    dirkspzm32.bde_fa_auftrag (
        ag_artikel_id
    );


-- sqlcl_snapshot {"hash":"3cff235db19cf287cf5597c3495ca417c9bc9515","type":"INDEX","name":"IX_BDE_FA_AG_ARTIKEL_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AG_ARTIKEL_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AG_ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}