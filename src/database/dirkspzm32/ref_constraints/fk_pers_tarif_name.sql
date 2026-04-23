alter table dirkspzm32.pzm_personal
    add constraint fk_pers_tarif_name
        foreign key ( tarif_name )
            references dirkspzm32.pzm_tarifmodelle ( tarif_name )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"1e88d938ad99d5291eef1e6667c51f0fefa67cf8","type":"REF_CONSTRAINT","name":"FK_PERS_TARIF_NAME","schemaName":"DIRKSPZM32","sxml":""}