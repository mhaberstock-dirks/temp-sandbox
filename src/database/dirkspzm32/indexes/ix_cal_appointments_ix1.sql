create index dirkspzm32.ix_cal_appointments_ix1 on
    dirkspzm32.cal_appointments (
        start_time,
        end_time
    );


-- sqlcl_snapshot {"hash":"f6614ca23fe46eed372f4a7108cb2857c4c3a7e2","type":"INDEX","name":"IX_CAL_APPOINTMENTS_IX1","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_CAL_APPOINTMENTS_IX1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>CAL_APPOINTMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>START_TIME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>END_TIME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}