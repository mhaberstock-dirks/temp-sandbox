create index dirkspzm32.ix_purch_pos_artikel on
    dirkspzm32.isi_purch_pos (
        artikel_id
    );


-- sqlcl_snapshot {"hash":"d58a6a2f9b22cc8dd98bb70c4fb432a11017feb6","type":"INDEX","name":"IX_PURCH_POS_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PURCH_POS_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_PURCH_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}