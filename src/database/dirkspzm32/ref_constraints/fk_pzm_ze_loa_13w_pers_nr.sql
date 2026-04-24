alter table dirkspzm32.pzm_ze_loa_13w_schnitt
    add constraint fk_pzm_ze_loa_13w_pers_nr
        foreign key ( pers_nr )
            references dirkspzm32.pzm_personal ( pers_nr )
                on delete cascade
        disable;


-- sqlcl_snapshot {"hash":"ebb7d79b1d5fc42607edba1497a750a3656d1305","type":"REF_CONSTRAINT","name":"FK_PZM_ZE_LOA_13W_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}