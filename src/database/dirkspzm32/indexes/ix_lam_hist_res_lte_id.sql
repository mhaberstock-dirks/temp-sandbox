create index dirkspzm32.ix_lam_hist_res_lte_id on
    dirkspzm32.lvs_lam_hist (
        res_ziel_lte_id
    );


-- sqlcl_snapshot {"hash":"b46812ce95909d7e81a7f991734b67f17fb1efe8","type":"INDEX","name":"IX_LAM_HIST_RES_LTE_ID","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LAM_HIST_RES_LTE_ID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LAM_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_ZIEL_LTE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}