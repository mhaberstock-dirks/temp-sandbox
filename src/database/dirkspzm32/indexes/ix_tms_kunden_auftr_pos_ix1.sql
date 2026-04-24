create index dirkspzm32.ix_tms_kunden_auftr_pos_ix1 on
    dirkspzm32.tms_kunden_auftr_pos (
        artikel_id
    );


-- sqlcl_snapshot {"hash":"0d875a28e0c341bf8d9ebb77eaa778ebad5b72c1","type":"INDEX","name":"IX_TMS_KUNDEN_AUFTR_POS_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_TMS_KUNDEN_AUFTR_POS_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>TMS_KUNDEN_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}