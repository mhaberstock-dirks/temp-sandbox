alter table dirkspzm32.bde_fa_auftrag_log
    add constraint fk_leitzahl
        foreign key ( leitzahl,
                      fa_ag,
                      fa_upos )
            references dirkspzm32.bde_fa_auftrag ( leitzahl,
                                                   fa_ag,
                                                   fa_upos )
        enable;


-- sqlcl_snapshot {"hash":"d6bee8ff6a51d7bdfbf86ef0d19abd636542ba24","type":"REF_CONSTRAINT","name":"FK_LEITZAHL","schemaName":"DIRKSPZM32","sxml":""}