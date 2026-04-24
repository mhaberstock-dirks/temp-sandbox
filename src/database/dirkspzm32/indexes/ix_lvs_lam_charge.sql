create index dirkspzm32.ix_lvs_lam_charge on
    dirkspzm32.lvs_lam (
        charge_id
    );


-- sqlcl_snapshot {"hash":"f857ab45deea24d961ba897750c850a7b47076d5","type":"INDEX","name":"IX_LVS_LAM_CHARGE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LAM_CHARGE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHARGE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}