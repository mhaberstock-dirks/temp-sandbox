alter table dirkspzm32.isi_resource
    add constraint fk_res_lager_fertig
        foreign key ( lager_fertig )
            references dirkspzm32.lvs_lgr ( lgr_platz )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"e2b770b153e2ae0e4dc894144162addd6f8ba6ed","type":"REF_CONSTRAINT","name":"FK_RES_LAGER_FERTIG","schemaName":"DIRKSPZM32","sxml":""}