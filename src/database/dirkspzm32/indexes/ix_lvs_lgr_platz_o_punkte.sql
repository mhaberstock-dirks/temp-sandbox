create index dirkspzm32.ix_lvs_lgr_platz_o_punkte on
    dirkspzm32.lvs_lgr ( replace(lgr_platz, '.') );


-- sqlcl_snapshot {"hash":"a8a731d31a63c8189d3317fac4c55a7cfc8d66f1","type":"INDEX","name":"IX_LVS_LGR_PLATZ_O_PUNKTE","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_LGR_PLATZ_O_PUNKTE</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_LGR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REPLACE(\"LGR_PLATZ\",'.')</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}