create index dirkspzm32.ix_lam_lte_id_lieferant on
    dirkspzm32.lvs_lam (
        lte_id_lieferant,
        lam_id
    );


-- sqlcl_snapshot {"hash":"3350ca429f1234b5dd00ded6c5a2f2b5f5888b02","type":"INDEX","name":"IX_LAM_LTE_ID_LIEFERANT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_LTE_ID_LIEFERANT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_ID_LIEFERANT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}