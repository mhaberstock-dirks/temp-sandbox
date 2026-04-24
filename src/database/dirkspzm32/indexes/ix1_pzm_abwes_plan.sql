create index dirkspzm32.ix1_pzm_abwes_plan on
    dirkspzm32.pzm_abwes_plan (
        monat,
        pers_nr
    );


-- sqlcl_snapshot {"hash":"a31a7e7754eb90e5a8132811ef55967118fb73ae","type":"INDEX","name":"IX1_PZM_ABWES_PLAN","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX1_PZM_ABWES_PLAN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ABWES_PLAN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MONAT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}