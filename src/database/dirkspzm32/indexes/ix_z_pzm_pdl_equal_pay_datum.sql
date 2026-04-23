create index dirkspzm32.ix_z_pzm_pdl_equal_pay_datum on
    dirkspzm32.pzm_pdl_kst_equal_pay (
        datum
    );


-- sqlcl_snapshot {"hash":"2abd56cbaf4a92e1c253838071deb961af671e08","type":"INDEX","name":"IX_Z_PZM_PDL_EQUAL_PAY_DATUM","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_Z_PZM_PDL_EQUAL_PAY_DATUM</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_PDL_KST_EQUAL_PAY</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DATUM</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}