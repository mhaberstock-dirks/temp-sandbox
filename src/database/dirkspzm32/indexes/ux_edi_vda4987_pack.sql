create unique index dirkspzm32.ux_edi_vda4987_pack on
    dirkspzm32.edi_vda4987_pack (
        pack_item_id,
        pos
    );


-- sqlcl_snapshot {"hash":"ea589e2dd33cae792b1e4a6da8ea7086a0c012c8","type":"INDEX","name":"UX_EDI_VDA4987_PACK","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UX_EDI_VDA4987_PACK</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>EDI_VDA4987_PACK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PACK_ITEM_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}