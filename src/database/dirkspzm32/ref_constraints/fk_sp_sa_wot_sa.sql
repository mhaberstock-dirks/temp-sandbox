alter table dirkspzm32.pzm_schicht_perioden
    add constraint fk_sp_sa_wot_sa
        foreign key ( sp_sa_wot_sa )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"d8bd427f8bb168fdcc839d0cbd8ae43b085e68d2","type":"REF_CONSTRAINT","name":"FK_SP_SA_WOT_SA","schemaName":"DIRKSPZM32","sxml":""}