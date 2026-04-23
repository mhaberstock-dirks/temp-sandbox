alter table dirkspzm32.pzm_schicht_perioden
    add constraint fk_sp_sa_wot_mo
        foreign key ( sp_sa_wot_mo )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"83e5b48a0e97df432b3023552bb4435bf9c132c5","type":"REF_CONSTRAINT","name":"FK_SP_SA_WOT_MO","schemaName":"DIRKSPZM32","sxml":""}