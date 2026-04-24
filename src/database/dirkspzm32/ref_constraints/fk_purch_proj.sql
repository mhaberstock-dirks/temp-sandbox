alter table dirkspzm32.isi_purch_kopf
    add constraint fk_purch_proj
        foreign key ( project_nr )
            references dirkspzm32.isi_project ( project_nr )
        enable;


-- sqlcl_snapshot {"hash":"d31ecc128e0beba346cc1caa78dab8871062ed01","type":"REF_CONSTRAINT","name":"FK_PURCH_PROJ","schemaName":"DIRKSPZM32","sxml":""}