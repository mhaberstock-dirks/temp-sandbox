alter table dirkspzm32.pzm_schicht_perioden
    add constraint fk_sp_sa_wot_mi
        foreign key ( sp_sa_wot_mi )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"04215dbd5100b89a5a96913d6c4bb235016e32a9","type":"REF_CONSTRAINT","name":"FK_SP_SA_WOT_MI","schemaName":"DIRKSPZM32","sxml":""}