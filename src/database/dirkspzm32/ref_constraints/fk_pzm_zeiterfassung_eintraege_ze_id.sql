alter table dirkspzm32.pzm_zeiterfassung_eintraege
    add constraint fk_pzm_zeiterfassung_eintraege_ze_id
        foreign key ( ze_id )
            references dirkspzm32.pzm_zeiterfassung ( ze_id )
                on delete set null
        enable;


-- sqlcl_snapshot {"hash":"053d3961cfee5580714522ba2d35347391957df3","type":"REF_CONSTRAINT","name":"FK_PZM_ZEITERFASSUNG_EINTRAEGE_ZE_ID","schemaName":"DIRKSPZM32","sxml":""}