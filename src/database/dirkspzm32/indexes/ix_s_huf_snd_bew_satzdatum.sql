create index dirkspzm32.ix_s_huf_snd_bew_satzdatum on
    dirkspzm32.s_huf_send_bew (
        satzdatum,
        status
    );


-- sqlcl_snapshot {"hash":"38f0cda4042b77688409f9e8816d2f6566b54a13","type":"INDEX","name":"IX_S_HUF_SND_BEW_SATZDATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_HUF_SND_BEW_SATZDATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_HUF_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SATZDATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}