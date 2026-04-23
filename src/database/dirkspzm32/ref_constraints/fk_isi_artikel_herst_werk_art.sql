alter table dirkspzm32.isi_artikel_hersteller_werk
    add constraint fk_isi_artikel_herst_werk_art
        foreign key ( artikel_id )
            references dirkspzm32.isi_artikel ( artikel_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"b910aaefedc16332fd1ef4cbed1db3716d957a30","type":"REF_CONSTRAINT","name":"FK_ISI_ARTIKEL_HERST_WERK_ART","schemaName":"DIRKSPZM32","sxml":""}