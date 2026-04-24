create index dirkspzm32.ix_artikel_ctrl_zeichn on
    dirkspzm32.isi_artikel_ctrl (
        artikel_id,
        zeichnung,
        zeichnung_index
    );


-- sqlcl_snapshot {"hash":"f223e8e00bd1b3e5dab1cee31bda098568d65ed5","type":"INDEX","name":"IX_ARTIKEL_CTRL_ZEICHN","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_ARTIKEL_CTRL_ZEICHN</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARTIKEL_CTRL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZEICHNUNG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZEICHNUNG_INDEX</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}