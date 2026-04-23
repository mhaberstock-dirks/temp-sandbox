create unique index dirkspzm32.uix_arbeitspl_hostname on
    dirkspzm32.isi_arbeitsplatz ( lower(ip_name) );


-- sqlcl_snapshot {"hash":"e58f69d5a8a4bda7f71841975e92f03807f13f6e","type":"INDEX","name":"UIX_ARBEITSPL_HOSTNAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UIX_ARBEITSPL_HOSTNAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_ARBEITSPLATZ</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOWER(\"IP_NAME\")</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}