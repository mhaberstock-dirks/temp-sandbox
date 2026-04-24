create index dirkspzm32.ix_isi_lief_vorg_id on
    dirkspzm32.isi_liefs (
        vorgang_id
    );


-- sqlcl_snapshot {"hash":"0ff46aec0ba82df44fcd33985f88f787baf36a8f","type":"INDEX","name":"IX_ISI_LIEF_VORG_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_LIEF_VORG_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_LIEFS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VORGANG_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}