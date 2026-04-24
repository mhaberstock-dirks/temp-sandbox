create index dirkspzm32.ix_linien_waren on
    dirkspzm32.lvs_prod_linie_waren (
        linie_nr
    );


-- sqlcl_snapshot {"hash":"dcca590a4653385f3aff292dd680c602dc7a0880","type":"INDEX","name":"IX_LINIEN_WAREN","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LINIEN_WAREN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_PROD_LINIE_WAREN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LINIE_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}