alter table dirkspzm32.lvs_serie_id_pos
    add constraint fk_serie_id
        foreign key ( serie_id )
            references dirkspzm32.lvs_serie_id_kopf ( serie_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"a9cc271dc6206e1e8811135685f6475036c32982","type":"REF_CONSTRAINT","name":"FK_SERIE_ID","schemaName":"DIRKSPZM32","sxml":""}