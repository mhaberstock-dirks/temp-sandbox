create index dirkspzm32.i_bf_buchung_sb on
    dirkspzm32.s_huf_send_bew (
        status,
        bewegungsart
    );


-- sqlcl_snapshot {"hash":"14bebee9cb8ef5644caffb79b2bfeca6980c9b45","type":"INDEX","name":"I_BF_BUCHUNG_SB","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>I_BF_BUCHUNG_SB</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_HUF_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEWEGUNGSART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}