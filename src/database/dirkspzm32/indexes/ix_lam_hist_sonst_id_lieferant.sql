create index dirkspzm32.ix_lam_hist_sonst_id_lieferant on
    dirkspzm32.lvs_lam_hist (
        sonst_id_lieferant,
        lam_id
    );


-- sqlcl_snapshot {"hash":"59975d8b150ecf99043c1e79692351411b480213","type":"INDEX","name":"IX_LAM_HIST_SONST_ID_LIEFERANT","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_HIST_SONST_ID_LIEFERANT</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SONST_ID_LIEFERANT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LAM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}