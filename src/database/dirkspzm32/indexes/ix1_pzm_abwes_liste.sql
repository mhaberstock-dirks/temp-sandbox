create index dirkspzm32.ix1_pzm_abwes_liste on
    dirkspzm32.pzm_abwes_liste (
        monat,
        pers_nr
    );


-- sqlcl_snapshot {"hash":"085d0ececc7a217cda1ba19e48c93c133e8216ab","type":"INDEX","name":"IX1_PZM_ABWES_LISTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX1_PZM_ABWES_LISTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_ABWES_LISTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>MONAT</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}