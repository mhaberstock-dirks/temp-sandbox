create index dirkspzm32.ix_bde_fa_kopf_soll_start on
    dirkspzm32.bde_fa_kopf (
        termin_soll_start,
        fa_nr
    );


-- sqlcl_snapshot {"hash":"793c257d92344dcd03d5b4fc14c6a7087cd7f850","type":"INDEX","name":"IX_BDE_FA_KOPF_SOLL_START","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_KOPF_SOLL_START</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TERMIN_SOLL_START</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}