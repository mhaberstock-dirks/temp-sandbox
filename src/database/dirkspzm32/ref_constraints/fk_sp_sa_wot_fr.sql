alter table dirkspzm32.pzm_schicht_perioden
    add constraint fk_sp_sa_wot_fr
        foreign key ( sp_sa_wot_fr )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"d72df725eadb285e2e6e2a96537b5f94dae9f063","type":"REF_CONSTRAINT","name":"FK_SP_SA_WOT_FR","schemaName":"DIRKSPZM32","sxml":""}