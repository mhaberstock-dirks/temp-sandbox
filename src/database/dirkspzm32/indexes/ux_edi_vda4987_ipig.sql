create unique index dirkspzm32.ux_edi_vda4987_ipig on
    dirkspzm32.edi_vda4987_ipig (
        ipig_id,
        pos
    );


-- sqlcl_snapshot {"hash":"2947dc002054f4af0aa16e789e3d459df34f7f99","type":"INDEX","name":"UX_EDI_VDA4987_IPIG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UX_EDI_VDA4987_IPIG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>EDI_VDA4987_IPIG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>IPIG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}