create index dirkspzm32.ix_artikel_lieferant_ix1 on
    dirkspzm32.isi_artikel_lieferant (
        lieferant_nr
    );


-- sqlcl_snapshot {"hash":"32f27a8510bd798cfa12dbcef75bb346c776607c","type":"INDEX","name":"IX_ARTIKEL_LIEFERANT_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ARTIKEL_LIEFERANT_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_LIEFERANT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LIEFERANT_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}