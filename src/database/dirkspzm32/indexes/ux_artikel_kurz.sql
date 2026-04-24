create unique index dirkspzm32.ux_artikel_kurz on
    dirkspzm32.s_rcv_artikel (
        artikel_kurz
    );


-- sqlcl_snapshot {"hash":"8e7d98c902ff888f40bc9b7381013111a718b673","type":"INDEX","name":"UX_ARTIKEL_KURZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UX_ARTIKEL_KURZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_ARTIKEL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_KURZ</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}