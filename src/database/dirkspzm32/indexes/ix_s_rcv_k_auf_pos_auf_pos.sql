create index dirkspzm32.ix_s_rcv_k_auf_pos_auf_pos on
    dirkspzm32.s_rcv_kunden_auftr_pos (
        auftrag,
        pos_nr
    );


-- sqlcl_snapshot {"hash":"ee3525ab3cc3f8a2cec29e028719edfa5ff112e4","type":"INDEX","name":"IX_S_RCV_K_AUF_POS_AUF_POS","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RCV_K_AUF_POS_AUF_POS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_KUNDEN_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AUFTRAG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}