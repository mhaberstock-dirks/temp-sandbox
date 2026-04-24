alter table dirkspzm32.isi_artikel_hersteller
    add constraint fk_isi_artikel_hersteller_art
        foreign key ( artikel_id )
            references dirkspzm32.isi_artikel ( artikel_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"3aa59f50b3c6736e3040cf937c27cc6ad22e1e73","type":"REF_CONSTRAINT","name":"FK_ISI_ARTIKEL_HERSTELLER_ART","schemaName":"DIRKSPZM32","sxml":""}