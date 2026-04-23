create index dirkspzm32.ix_z_pzm_pdl_equal_pay_pb_id on
    dirkspzm32.pzm_pdl_kst_equal_pay (
        pb_id,
        pers_nr,
        datum,
        lohnart
    );


-- sqlcl_snapshot {"hash":"03acb12b0a657310e15005e8903f61078f34ba33","type":"INDEX","name":"IX_Z_PZM_PDL_EQUAL_PAY_PB_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_Z_PZM_PDL_EQUAL_PAY_PB_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_PDL_KST_EQUAL_PAY</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PB_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PERS_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOHNART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}