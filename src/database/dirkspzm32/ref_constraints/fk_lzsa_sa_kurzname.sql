alter table dirkspzm32.pzm_lz_sa
    add constraint fk_lzsa_sa_kurzname
        foreign key ( lzsa_sa_kurzname )
            references dirkspzm32.pzm_schichtarten ( sa_kurzname )
        disable;


-- sqlcl_snapshot {"hash":"0ca0b2fe30dce436d4b154fd1744ca1ce4b5515d","type":"REF_CONSTRAINT","name":"FK_LZSA_SA_KURZNAME","schemaName":"DIRKSPZM32","sxml":""}