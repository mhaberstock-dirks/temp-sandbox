create unique index dirkspzm32.ix_dw_bde_pdod_res_typ_zeit on
    dirkspzm32.dw_bde_prod_daten (
        res_id,
        dw_bde_typ,
        dw_bde_datum_start
    )
        reverse;


-- sqlcl_snapshot {"hash":"dbe0cb45565048aa26a1725f7ece9222e9658f99","type":"INDEX","name":"IX_DW_BDE_PDOD_RES_TYP_ZEIT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_DW_BDE_PDOD_RES_TYP_ZEIT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>DW_BDE_PROD_DATEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DW_BDE_TYP</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DW_BDE_DATUM_START</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}