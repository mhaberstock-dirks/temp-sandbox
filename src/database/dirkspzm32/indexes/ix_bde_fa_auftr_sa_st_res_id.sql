create index dirkspzm32.ix_bde_fa_auftr_sa_st_res_id on
    dirkspzm32.bde_fa_auftrag (
        satzart,
        freig_status,
        res_id,
        termin_start_gepl
    );


-- sqlcl_snapshot {"hash":"9f03be92692d48e549e3fb67ff548c7392c77dd1","type":"INDEX","name":"IX_BDE_FA_AUFTR_SA_ST_RES_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AUFTR_SA_ST_RES_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SATZART</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FREIG_STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TERMIN_START_GEPL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}