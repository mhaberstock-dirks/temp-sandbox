create index dirkspzm32.ix_bewegungsart on
    dirkspzm32.s_huf_send_bew (
        bewegungsart
    );


-- sqlcl_snapshot {"hash":"245a192a0c52cedc341f41442543118de68445ac","type":"INDEX","name":"IX_BEWEGUNGSART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BEWEGUNGSART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_HUF_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>BEWEGUNGSART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}