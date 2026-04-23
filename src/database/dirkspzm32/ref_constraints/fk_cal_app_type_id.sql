alter table dirkspzm32.cal_res_appointment_types
    add constraint fk_cal_app_type_id
        foreign key ( cal_appointment_type_id )
            references dirkspzm32.cal_appointment_types ( id )
        enable;


-- sqlcl_snapshot {"hash":"099fc41f9f3da25ec1c032883b0af390f5e2b9c1","type":"REF_CONSTRAINT","name":"FK_CAL_APP_TYPE_ID","schemaName":"DIRKSPZM32","sxml":""}