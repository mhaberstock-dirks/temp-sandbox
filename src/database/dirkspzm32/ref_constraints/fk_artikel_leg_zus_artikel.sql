alter table dirkspzm32.isi_artikel
    add constraint fk_artikel_leg_zus_artikel
        foreign key ( leg_zuschlag_artikel_id )
            references dirkspzm32.isi_artikel ( artikel_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"99318987f0f7c813dbce0f21bb105760b61a91a3","type":"REF_CONSTRAINT","name":"FK_ARTIKEL_LEG_ZUS_ARTIKEL","schemaName":"DIRKSPZM32","sxml":""}