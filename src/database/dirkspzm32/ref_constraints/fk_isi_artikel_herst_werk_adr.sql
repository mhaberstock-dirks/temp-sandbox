alter table dirkspzm32.isi_artikel_hersteller_werk
    add constraint fk_isi_artikel_herst_werk_adr
        foreign key ( adress_id )
            references dirkspzm32.isi_adressen ( adress_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"01169aaa18fee71d3977b32ed49452fb0047e7b4","type":"REF_CONSTRAINT","name":"FK_ISI_ARTIKEL_HERST_WERK_ADR","schemaName":"DIRKSPZM32","sxml":""}