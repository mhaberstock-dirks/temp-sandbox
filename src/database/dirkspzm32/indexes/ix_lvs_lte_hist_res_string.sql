create index dirkspzm32.ix_lvs_lte_hist_res_string on
    dirkspzm32.lvs_lte_hist (
        res_string
    );


-- sqlcl_snapshot {"hash":"c97bb29683b4176c52d311b79c209d72e19d67f3","type":"INDEX","name":"IX_LVS_LTE_HIST_RES_STRING","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LTE_HIST_RES_STRING</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LTE_HIST</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_STRING</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}