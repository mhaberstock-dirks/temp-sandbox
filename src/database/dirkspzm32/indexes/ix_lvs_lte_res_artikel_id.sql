create index dirkspzm32.ix_lvs_lte_res_artikel_id on
    dirkspzm32.lvs_lte (
        res_artikel_id
    );


-- sqlcl_snapshot {"hash":"2a0332b980cc46cba6c5878eea693020754ddd57","type":"INDEX","name":"IX_LVS_LTE_RES_ARTIKEL_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_RES_ARTIKEL_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}