alter table dirkspzm32.pzm_azubi_daten
    add constraint fk_ad_pers_nr
        foreign key ( ad_pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete cascade
        disable;


-- sqlcl_snapshot {"hash":"b0d1679b1f13d2acfe2d9f030f321844b5cee180","type":"REF_CONSTRAINT","name":"FK_AD_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}