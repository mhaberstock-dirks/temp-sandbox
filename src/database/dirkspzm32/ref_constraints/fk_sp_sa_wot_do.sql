alter table dirkspzm32.pzm_schicht_perioden
    add constraint fk_sp_sa_wot_do
        foreign key ( sp_sa_wot_do )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"d6f659e998bbd66a8509c9f0fbcd265f86ea0354","type":"REF_CONSTRAINT","name":"FK_SP_SA_WOT_DO","schemaName":"DIRKSPZM32","sxml":""}