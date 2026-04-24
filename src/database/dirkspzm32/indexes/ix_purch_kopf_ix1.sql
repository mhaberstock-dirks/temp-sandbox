create index dirkspzm32.ix_purch_kopf_ix1 on
    dirkspzm32.isi_purch_kopf (
        erz_datum,
        status
    );


-- sqlcl_snapshot {"hash":"8a6232477b9bb035f9fb2d0b4b42b7866812d91b","type":"INDEX","name":"IX_PURCH_KOPF_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PURCH_KOPF_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_PURCH_KOPF</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERZ_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}