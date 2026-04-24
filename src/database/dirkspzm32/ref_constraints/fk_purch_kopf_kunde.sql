alter table dirkspzm32.isi_purch_kopf
    add constraint fk_purch_kopf_kunde
        foreign key ( kunde_id )
            references dirkspzm32.isi_adressen ( adress_id )
        enable;


-- sqlcl_snapshot {"hash":"82140cc29378583c0c11bb0553021e4a33eb1c6a","type":"REF_CONSTRAINT","name":"FK_PURCH_KOPF_KUNDE","schemaName":"DIRKSPZM32","sxml":""}