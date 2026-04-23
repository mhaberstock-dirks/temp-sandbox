alter table dirkspzm32.pzm_abteilungen
    add constraint fk_abt_tarif_name
        foreign key ( tarif_name )
            references dirkspzm32.pzm_tarifmodelle ( tarif_name )
        disable;


-- sqlcl_snapshot {"hash":"30a46b8f54ec4ca061aa55379ac9112a4a4f14b4","type":"REF_CONSTRAINT","name":"FK_ABT_TARIF_NAME","schemaName":"DIRKSPZM32","sxml":""}