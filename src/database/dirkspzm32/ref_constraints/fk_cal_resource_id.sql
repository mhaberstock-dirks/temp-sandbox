alter table dirkspzm32.cal_res_appointment_types
    add constraint fk_cal_resource_id
        foreign key ( cal_resource_id )
            references dirkspzm32.cal_resources ( id )
        enable;


-- sqlcl_snapshot {"hash":"9c90f95cbf3270979371fb2f7663dce5d56f68ba","type":"REF_CONSTRAINT","name":"FK_CAL_RESOURCE_ID","schemaName":"DIRKSPZM32","sxml":""}