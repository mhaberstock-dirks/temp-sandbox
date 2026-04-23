create index dirkspzm32.ix_aps_fa_vorg_pos_ix1 on
    dirkspzm32.aps_fa_vorgangs_position ( to_number(substr(fakopfnr, 3)),
        favorgangsnr,
        favorgangssplittnr,
        typ
    );


-- sqlcl_snapshot {"hash":"329ea320f90b6e18f224fc35e7fd03813678b6b7","type":"INDEX","name":"IX_APS_FA_VORG_POS_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_FA_VORG_POS_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_FA_VORGANGS_POSITION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TO_NUMBER(SUBSTR(\"FAKOPFNR\",3))</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FAVORGANGSNR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FAVORGANGSSPLITTNR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>TYP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}