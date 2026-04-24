alter table dirkspzm32.isi_komm_zeit
    add constraint fk_komm_zeit_res
        foreign key ( bearb_res_id )
            references dirkspzm32.isi_resource ( res_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"b67153ecc453d26ebdfd21a87bfa37ca9a56333d","type":"REF_CONSTRAINT","name":"FK_KOMM_ZEIT_RES","schemaName":"DIRKSPZM32","sxml":""}