create index dirkspzm32.ix_isi_artikel_kunde_artikel on
    dirkspzm32.isi_artikel_kunde (
        artikel_id
    );


-- sqlcl_snapshot {"hash":"cba7c1e8ec00541924e602d6fa2718709d08635f","type":"INDEX","name":"IX_ISI_ARTIKEL_KUNDE_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ISI_ARTIKEL_KUNDE_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_KUNDE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}