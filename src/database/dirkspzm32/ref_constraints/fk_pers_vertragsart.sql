alter table dirkspzm32.pzm_personal
    add constraint fk_pers_vertragsart
        foreign key ( pers_vertragsart )
            references dirkspzm32.pzm_vertragsarten ( va_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"6631ec17e83bbf4ade7302e43c32dbc2c99639ea","type":"REF_CONSTRAINT","name":"FK_PERS_VERTRAGSART","schemaName":"DIRKSPZM32","sxml":""}