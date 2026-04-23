create index dirkspzm32.ix_stueckliste_artikel_stl_id on
    dirkspzm32.pps_stueckliste_pos (
        artikel_id,
        stueckliste_id
    );


-- sqlcl_snapshot {"hash":"7ef16586c8fd66afdbb2ffd3dfec5f973e0c0f11","type":"INDEX","name":"IX_STUECKLISTE_ARTIKEL_STL_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_STUECKLISTE_ARTIKEL_STL_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_STUECKLISTE_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STUECKLISTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}