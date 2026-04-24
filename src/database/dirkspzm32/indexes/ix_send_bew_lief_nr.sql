create index dirkspzm32.ix_send_bew_lief_nr on
    dirkspzm32.s_send_bew (
        ext_lief_nr
    );


-- sqlcl_snapshot {"hash":"20589e95f83ce520c9738ad326022bb70000404e","type":"INDEX","name":"IX_SEND_BEW_LIEF_NR","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_SEND_BEW_LIEF_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EXT_LIEF_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}