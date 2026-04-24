alter table dirkspzm32.pzm_schicht_perioden
    add constraint fk_sp_sa_wot_di
        foreign key ( sp_sa_wot_di )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"dfcbd9073af76d71a668ca237c7af8f2a50b211a","type":"REF_CONSTRAINT","name":"FK_SP_SA_WOT_DI","schemaName":"DIRKSPZM32","sxml":""}