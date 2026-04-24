create index dirkspzm32.ix_artikel_ctrl_funktion on
    dirkspzm32.isi_artikel_ctrl (
        funktion,
        artikel_id
    );


-- sqlcl_snapshot {"hash":"8ace3128c0fd908457d893ea0f35fdc6ea6e8632","type":"INDEX","name":"IX_ARTIKEL_CTRL_FUNKTION","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ARTIKEL_CTRL_FUNKTION</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_CTRL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FUNKTION</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}