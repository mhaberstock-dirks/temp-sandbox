create index dirkspzm32.ix_aps_fa_vorgangs_position on
    dirkspzm32.aps_fa_vorgangs_position (
        fakopfnr,
        favorgangsnr,
        favorgangsalternative,
        favorgangssplittnr,
        favorgangspositionsnr
    );


-- sqlcl_snapshot {"hash":"29ea6fccdef92670c9d73066c346b0616c485a0a","type":"INDEX","name":"IX_APS_FA_VORGANGS_POSITION","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_APS_FA_VORGANGS_POSITION</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>APS_FA_VORGANGS_POSITION</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FAKOPFNR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FAVORGANGSNR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FAVORGANGSALTERNATIVE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FAVORGANGSSPLITTNR</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FAVORGANGSPOSITIONSNR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}