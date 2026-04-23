create unique index dirkspzm32.ux_edi_vda4987_hu on
    dirkspzm32.edi_vda4987_hu (
        hu_id,
        pos
    );


-- sqlcl_snapshot {"hash":"0d66ef169e50958def438cec64c61523d3fe295a","type":"INDEX","name":"UX_EDI_VDA4987_HU","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UX_EDI_VDA4987_HU</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>EDI_VDA4987_HU</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>HU_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}