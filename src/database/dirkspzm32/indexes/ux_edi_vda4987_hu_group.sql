create unique index dirkspzm32.ux_edi_vda4987_hu_group on
    dirkspzm32.edi_vda4987_hu_group (
        hug_id,
        pos
    );


-- sqlcl_snapshot {"hash":"e50fe12d9b12b6b63c3614ee4de6680b03c5a871","type":"INDEX","name":"UX_EDI_VDA4987_HU_GROUP","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UX_EDI_VDA4987_HU_GROUP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>EDI_VDA4987_HU_GROUP</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>HUG_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>POS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}