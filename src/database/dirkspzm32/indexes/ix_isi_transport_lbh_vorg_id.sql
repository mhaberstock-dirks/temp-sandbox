create index dirkspzm32.ix_isi_transport_lbh_vorg_id on
    dirkspzm32.isi_transport_hist (
        lam_bh_vorgang_id,
        ts
    );


-- sqlcl_snapshot {"hash":"6f40f2529e3fa0fbf7d6089d5da45b9435798dad","type":"INDEX","name":"IX_ISI_TRANSPORT_LBH_VORG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_LBH_VORG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LAM_BH_VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}