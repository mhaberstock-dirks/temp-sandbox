create index dirkspzm32.ix_purch_pos_ix3 on
    dirkspzm32.isi_purch_pos (
        lief_plan_abr_kal_id
    );


-- sqlcl_snapshot {"hash":"6f2e43475c9b11c47c85b9cb586140b724f79a8e","type":"INDEX","name":"IX_PURCH_POS_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PURCH_POS_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_PURCH_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LIEF_PLAN_ABR_KAL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}