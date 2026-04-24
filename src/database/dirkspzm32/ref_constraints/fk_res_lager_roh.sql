alter table dirkspzm32.isi_resource
    add constraint fk_res_lager_roh
        foreign key ( lager_roh )
            references dirkspzm32.lvs_lgr ( lgr_platz )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"182600e9bd0c81f765648c72cfa66383e0d23b39","type":"REF_CONSTRAINT","name":"FK_RES_LAGER_ROH","schemaName":"DIRKSPZM32","sxml":""}