create index dirkspzm32.ix_s_rcv_k_auf_pos_ki_date on
    dirkspzm32.s_rcv_kunden_auftr_pos (
        kom_info,
        order_datum
    );


-- sqlcl_snapshot {"hash":"020bcc7347c42b20a44494882dd2808c9295ab16","type":"INDEX","name":"IX_S_RCV_K_AUF_POS_KI_DATE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_RCV_K_AUF_POS_KI_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_RCV_KUNDEN_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOM_INFO</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ORDER_DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}