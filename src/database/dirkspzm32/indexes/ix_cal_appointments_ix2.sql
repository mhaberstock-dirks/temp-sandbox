create index dirkspzm32.ix_cal_appointments_ix2 on
    dirkspzm32.cal_appointments (
        calendar_id
    );


-- sqlcl_snapshot {"hash":"8ecd513e5e51234779512fba11bf3d84d1992d33","type":"INDEX","name":"IX_CAL_APPOINTMENTS_IX2","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_CAL_APPOINTMENTS_IX2</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>CAL_APPOINTMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CALENDAR_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}