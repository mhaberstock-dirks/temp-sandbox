create index dirkspzm32.ix_purch_pos_kopf on
    dirkspzm32.isi_purch_pos (
        kopf_id
    );


-- sqlcl_snapshot {"hash":"c4196f30648e16e06839ac92ab59bb5769c3df4e","type":"INDEX","name":"IX_PURCH_POS_KOPF","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_PURCH_POS_KOPF</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_PURCH_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KOPF_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}