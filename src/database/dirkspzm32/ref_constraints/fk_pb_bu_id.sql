alter table dirkspzm32.pzm_produktionsbereiche_bu
    add constraint fk_pb_bu_id
        foreign key ( bu_id )
            references dirkspzm32.pzm_prod_business_units_bereiche ( bu_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"9bed38f3d05d600a0c91dcacab46a9edfb75943e","type":"REF_CONSTRAINT","name":"FK_PB_BU_ID","schemaName":"DIRKSPZM32","sxml":""}