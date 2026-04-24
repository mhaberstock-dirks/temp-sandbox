alter table dirkspzm32.pzm_ze_azk_urlaub
    add constraint fk_pzm_ze_azk_urlaub_kst
        foreign key ( pers_kst_id )
            references dirkspzm32.isi_kostenstellen ( kst_nr )
        disable;


-- sqlcl_snapshot {"hash":"ec1a55a26d551e4362cfe697b5bcf9e113078647","type":"REF_CONSTRAINT","name":"FK_PZM_ZE_AZK_URLAUB_KST","schemaName":"DIRKSPZM32","sxml":""}