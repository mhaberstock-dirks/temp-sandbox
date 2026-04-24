create index dirkspzm32.ix_send_bew_auf_id on
    dirkspzm32.s_send_bew (
        auf_id
    );


-- sqlcl_snapshot {"hash":"866f60e44d80ed79d61a584bf3432dd9909f7ab8","type":"INDEX","name":"IX_SEND_BEW_AUF_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_SEND_BEW_AUF_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}