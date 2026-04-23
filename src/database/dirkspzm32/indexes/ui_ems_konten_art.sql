create unique index dirkspzm32.ui_ems_konten_art on
    dirkspzm32.ems_konten_art (
        ems_konto_nr,
        ems_art_name
    );


-- sqlcl_snapshot {"hash":"f7aceafbe420bf94b240d9f9fb0419c434ca481b","type":"INDEX","name":"UI_EMS_KONTEN_ART","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UI_EMS_KONTEN_ART</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>EMS_KONTEN_ART</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EMS_KONTO_NR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EMS_ART_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}