create index dirkspzm32.ix_bde_pd_prozess_data_date on
    dirkspzm32.bde_pd_prozess_data (
        res_prozess_data_date
    );


-- sqlcl_snapshot {"hash":"ddeb940a2c61f4ccebc74afeae5cd132e78b71af","type":"INDEX","name":"IX_BDE_PD_PROZESS_DATA_DATE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_PD_PROZESS_DATA_DATE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_PD_PROZESS_DATA</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RES_PROZESS_DATA_DATE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}