create index dirkspzm32.ix_komm_order_lgr_platz on
    dirkspzm32.isi_komm_order (
        komm_lgr_platz
    );


-- sqlcl_snapshot {"hash":"009d7bb45748d707e87ebc46b11b5baa83efa573","type":"INDEX","name":"IX_KOMM_ORDER_LGR_PLATZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_KOMM_ORDER_LGR_PLATZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_KOMM_ORDER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOMM_LGR_PLATZ</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}