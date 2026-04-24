create index dirkspzm32.ix_isi_contact_ix1 on
    dirkspzm32.isi_contact (
        adress_id,
        aktiv
    );


-- sqlcl_snapshot {"hash":"25c0deba0effa19d06a317d137ecf3f3803bc9bf","type":"INDEX","name":"IX_ISI_CONTACT_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_CONTACT_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_CONTACT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ADRESS_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AKTIV</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}