alter table dirkspzm32.cal_appointments
    add constraint fk_cal_appointments1
        foreign key ( calendar_id )
            references dirkspzm32.cal_cfg ( calendar_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"5f2dae286ff797a8cc5bd9b6efdc6d0e7ab6c5ca","type":"REF_CONSTRAINT","name":"FK_CAL_APPOINTMENTS1","schemaName":"DIRKSPZM32","sxml":""}