create unique index dirkspzm32.ux_schicht_modell_name on
    dirkspzm32.isi_res_schicht_modell (
        schicht_modell_name
    );


-- sqlcl_snapshot {"hash":"d3e5fc7c5e47e35cc3879662f65626fd5185ae3f","type":"INDEX","name":"UX_SCHICHT_MODELL_NAME","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>UX_SCHICHT_MODELL_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_RES_SCHICHT_MODELL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SCHICHT_MODELL_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}