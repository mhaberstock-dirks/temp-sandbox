alter table dirkspzm32.pzm_personal
    add constraint fk_pers_region_code
        foreign key ( pers_region_code )
            references dirkspzm32.isi_land_region ( code )
        disable;


-- sqlcl_snapshot {"hash":"a316ac337b00d2b84e5d2d543a67824c823eff0a","type":"REF_CONSTRAINT","name":"FK_PERS_REGION_CODE","schemaName":"DIRKSPZM32","sxml":""}