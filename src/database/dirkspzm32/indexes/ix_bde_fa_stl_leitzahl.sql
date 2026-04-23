create index dirkspzm32.ix_bde_fa_stl_leitzahl on
    dirkspzm32.bde_fa_auftrag_stl (
        leitzahl
    );


-- sqlcl_snapshot {"hash":"ee8ad80d3a548aa770d3fa0b86a2d0ec2a7c6026","type":"INDEX","name":"IX_BDE_FA_STL_LEITZAHL","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_BDE_FA_STL_LEITZAHL</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>BDE_FA_AUFTRAG_STL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LEITZAHL</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}