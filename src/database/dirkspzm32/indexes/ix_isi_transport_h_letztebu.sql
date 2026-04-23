create index dirkspzm32.ix_isi_transport_h_letztebu on
    dirkspzm32.isi_transport_hist (
        lte_letzte_buchung
    );


-- sqlcl_snapshot {"hash":"4ca204687800000519fcaa81e04edb0cb52a9d67","type":"INDEX","name":"IX_ISI_TRANSPORT_H_LETZTEBU","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_TRANSPORT_H_LETZTEBU</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TRANSPORT_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LTE_LETZTE_BUCHUNG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}