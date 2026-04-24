create index dirkspzm32.ix_bde_fa_kopf_status on
    dirkspzm32.bde_fa_kopf (
        status,
        fa_nr
    );


-- sqlcl_snapshot {"hash":"4c3d0df2ceedceda9268a5331becc17ea4993bf8","type":"INDEX","name":"IX_BDE_FA_KOPF_STATUS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_KOPF_STATUS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FA_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}