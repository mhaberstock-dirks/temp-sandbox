create index dirkspzm32.ix_s_erp_send_bew_ext_auftrag on
    dirkspzm32.s_erp_send_bew (
        ext_auftrag,
        fehler_code
    );


-- sqlcl_snapshot {"hash":"935d005d349e20514a2f4595a27b28bd3d377a39","type":"INDEX","name":"IX_S_ERP_SEND_BEW_EXT_AUFTRAG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ERP_SEND_BEW_EXT_AUFTRAG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ERP_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EXT_AUFTRAG</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FEHLER_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}