create index dirkspzm32.ix_text_templates_1 on
    dirkspzm32.isi_text_templates (
        text_category,
        language_code
    );


-- sqlcl_snapshot {"hash":"8bce7b019ad4cfd73e2b9903ca5c29ed6e982c41","type":"INDEX","name":"IX_TEXT_TEMPLATES_1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_TEXT_TEMPLATES_1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>ISI_TEXT_TEMPLATES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TEXT_CATEGORY</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LANGUAGE_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}