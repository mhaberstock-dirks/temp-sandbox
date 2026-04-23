alter table dirkspzm32.isi_komm_client_platz
    add constraint fk_komm_client_name
        foreign key ( komm_client_name )
            references dirkspzm32.isi_komm_client ( komm_client_name )
        enable;


-- sqlcl_snapshot {"hash":"84a43449b0ddaf198886f40d4a2e22e137f2c0bd","type":"REF_CONSTRAINT","name":"FK_KOMM_CLIENT_NAME","schemaName":"DIRKSPZM32","sxml":""}