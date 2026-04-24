create index dirkspzm32.ix_bde_fa_auftrag_res_liste on
    dirkspzm32.bde_fa_auftrag_res_liste (
        leitzahl,
        firma_nr,
        sid
    );


-- sqlcl_snapshot {"hash":"4d1dc463fd52ffcb4bad0775c5a6568fedcd1bf7","type":"INDEX","name":"IX_BDE_FA_AUFTRAG_RES_LISTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_AUFTRAG_RES_LISTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_RES_LISTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRMA_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}