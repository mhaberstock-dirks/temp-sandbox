create index dirkspzm32.ix_res_typ_gruppe on
    dirkspzm32.isi_resource (
        gruppe,
        typ
    );


-- sqlcl_snapshot {"hash":"03379a695ae56be800a94187a4919617e2b66f7a","type":"INDEX","name":"IX_RES_TYP_GRUPPE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_RES_TYP_GRUPPE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RESOURCE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>GRUPPE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TYP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}