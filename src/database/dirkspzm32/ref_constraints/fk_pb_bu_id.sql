alter table dirkspzm32.pzm_produktionsbereiche_bu
    add constraint fk_pb_bu_id
        foreign key ( bu_id )
            references dirkspzm32.pzm_prod_business_units_bereiche ( bu_id )
        enable;


-- sqlcl_snapshot {"hash":"d4fe8a146a8a2dfe8f1248c486f43df1a4c14e66","type":"REF_CONSTRAINT","name":"FK_PB_BU_ID","schemaName":"DIRKSPZM32","sxml":""}