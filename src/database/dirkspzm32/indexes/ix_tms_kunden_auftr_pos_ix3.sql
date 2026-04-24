create index dirkspzm32.ix_tms_kunden_auftr_pos_ix3 on
    dirkspzm32.tms_kunden_auftr_pos (
        erz_datum,
        status,
        kunden_auftr_pos_id
    );


-- sqlcl_snapshot {"hash":"1c26a5675d9cf6d57d1d1e9e6188e35a8fb92d11","type":"INDEX","name":"IX_TMS_KUNDEN_AUFTR_POS_IX3","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_TMS_KUNDEN_AUFTR_POS_IX3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>TMS_KUNDEN_AUFTR_POS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERZ_DATUM</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KUNDEN_AUFTR_POS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}