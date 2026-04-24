create unique index dirkspzm32.viewport_name on
    dirkspzm32.mfr_viewports_cfg (
        viewport_name,
        viewport_scope
    );


-- sqlcl_snapshot {"hash":"e9e9806a72223a8d50bf35975610da73f5f0c4dc","type":"INDEX","name":"VIEWPORT_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>VIEWPORT_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>MFR_VIEWPORTS_CFG</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VIEWPORT_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VIEWPORT_SCOPE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}