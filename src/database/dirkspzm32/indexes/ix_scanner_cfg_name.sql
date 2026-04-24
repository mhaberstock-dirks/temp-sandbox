create index dirkspzm32.ix_scanner_cfg_name on
    dirkspzm32.isi_scanner_cfg (
        scanner_name
    );


-- sqlcl_snapshot {"hash":"5aae28794d8183e47defacf6d5c815498864735d","type":"INDEX","name":"IX_SCANNER_CFG_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_SCANNER_CFG_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_SCANNER_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SCANNER_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}