create index dirkspzm32.ix_z_pzm_pdl_equal_pay_loa on
    dirkspzm32.pzm_pdl_kst_equal_pay (
        lohnart
    );


-- sqlcl_snapshot {"hash":"ee92344150a741047d192ecb2d61fb51b45828eb","type":"INDEX","name":"IX_Z_PZM_PDL_EQUAL_PAY_LOA","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_Z_PZM_PDL_EQUAL_PAY_LOA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>PZM_PDL_KST_EQUAL_PAY</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOHNART</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}