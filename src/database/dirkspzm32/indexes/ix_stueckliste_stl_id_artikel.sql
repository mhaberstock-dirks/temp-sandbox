create index dirkspzm32.ix_stueckliste_stl_id_artikel on
    dirkspzm32.pps_stueckliste_pos (
        stueckliste_id,
        artikel_id
    );


-- sqlcl_snapshot {"hash":"7d7d038fc12db67cb1d94e69786f6af0e0f57ea4","type":"INDEX","name":"IX_STUECKLISTE_STL_ID_ARTIKEL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_STUECKLISTE_STL_ID_ARTIKEL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PPS_STUECKLISTE_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>STUECKLISTE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}