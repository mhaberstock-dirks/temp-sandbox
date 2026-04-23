alter table dirkspzm32.pzm_schicht_perioden
    add constraint fk_sp_sa_wot_so
        foreign key ( sp_sa_wot_so )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"c7905050b112e1893a45b54d28a0a68bbcb8e65e","type":"REF_CONSTRAINT","name":"FK_SP_SA_WOT_SO","schemaName":"DIRKSPZM32","sxml":""}