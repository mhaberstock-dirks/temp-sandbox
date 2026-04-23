create index dirkspzm32.ix_lvs_charge_bez on
    dirkspzm32.lvs_charge (
        charge_bez
    );


-- sqlcl_snapshot {"hash":"bddb36dc5d9d3797c3abee35bdf7bbb6f8cc5ebd","type":"INDEX","name":"IX_LVS_CHARGE_BEZ","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_LVS_CHARGE_BEZ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>LVS_CHARGE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CHARGE_BEZ</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}